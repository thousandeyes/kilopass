#!/bin/sh

unset TARGET SALT SHA

## Defaults
GEN=1
NONCE=0

## Constants
KPDIR="$HOME/.kilopass"
KPSALTFILE="$KPDIR/salt"
KPSALTSDIR="$KPDIR/salts"

necho() {
	# Mac's /bin/sh echo builtin doesn't have -n, so use external echo.
	/bin/echo -n $*
}

generator0() {
	# Just a big, ugly sha256sum.
	necho "$PASSWORD" | $SHA | cut -d ' ' -f 1 | tr -d '\n'
}

generator1() {
	# Upper/lower/number, 18 characters.
	# We don't have to worry about newlines from $SHA because xxd only reads the ascii-hex.
	# http://en.wikipedia.org/wiki/Base64 -- We strip / and + as they are possible. = should be
	# cut by the head -c 18. If the output is shorter than 18 bytes, we have a serious problem.
	necho "$PASSWORD" | $SHA | xxd -r -p | base64 | tr -d '+' | tr -d '/' | head -c 18
}

generator2() {
	# Upper/lower/number + special, 20 characters.
	# Tries to be compatible with services requiring a special character.
	# Not really any more secure than generator1.
	necho z
	necho "$PASSWORD" | $SHA | xxd -r -p | base64 | tr -d '+' | tr -d '/' | head -c 18
	necho '!'
}

generator3() {
	# Upper/lower/number + special, 12 characters.
	# More or less, only secure as 10 characters.
	necho a
	necho "$PASSWORD" | $SHA | xxd -r -p | base64 | tr -d '+' | tr -d '/' | head -c 10
	necho '!'
}

generator4() {
	# Upper/lower/number 12 characters.
	necho "$PASSWORD" | $SHA | xxd -r -p | base64 | tr -d '+' | tr -d '/' | head -c 12
}

generator5() {
	# Upper/lower/number 8 characters.
	necho "$PASSWORD" | $SHA | xxd -r -p | base64 | tr -d '+' | tr -d '/' | head -c 8
}


fail() {
	echo $0: $* 1>&2
	exit 1
}

help() {
	echo "Usage: $0 [-s SALT] [-f SALTFILE] [-n NONCE] [-g GEN] [-h HELP] <user@domain>"
	echo "Alternatively, create $KPSALTFILE with your salt, preferably chmod 600."
}

helperr() {
	help 1>&2
	exit 1
}

saltfile() {
	# If not a literal path, base it off of $KPSALTSDIR
	echo "$KPSALTFILE" | grep -q ^/ || KPSALTFILE="$KPSALTSDIR/$KPSALTFILE"
	[ -r "$KPSALTFILE" ] || fail "Create $KPSALTFILE or specific salt with -s"
	SALT=$(cat $KPSALTFILE | tr -d '\n')
}

# sha256 is generally on BSD, sha256sum generally on Linux. shasum on Mac.
which sha256 > /dev/null 2>&1 && SHA=sha256
which sha256sum > /dev/null 2>&1 && SHA="sha256sum -b"
which shasum > /dev/null 2>&1 && SHA="shasum -b -a 256"

[ -n "$SHA" ] || fail "Neither sha256 nor sha256sum found, exiting."

while [ $# -ne 0 ]; do
	case $1 in
		-h) help; exit 0;;
		-s) SALT=$2;shift;;
		-f) KPSALTFILE=$2;shift;;
		-n) NONCE=$2;shift;;
		-g) GEN=$2;shift;;
		 *) TARGET=$1;;
	esac
	shift
done

[ -n "$TARGET" ] || helperr
[ -n "$SALT" ] || saltfile
PASSWORD="$SALT^$NONCE^$TARGET"
generator${GEN} 2> /dev/null || fail "Try 0-4 as a generator, instead of $GEN."
