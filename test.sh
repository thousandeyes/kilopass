#!/bin/sh

KP=./kilopass.sh

fail() {
	echo $* 1>&2
	exit 1
}

check() {
	./kilopass.sh -s salty -g $1 peppery | grep ^$2$ || fail "Generation mode $1 did not output $2."
}

echo "Output is going to look pretty weird for a bit. It's expected."

./kilopass.sh && fail "Should return zero."
./kilopass.sh -h || fail "Help should return one."
./kilopass.sh -s salty peppery | grep '^hS580Ghp0Jc8l2dwdI$' || fail "Default salty peppery failed."
check 0 8733c96b306a12f7fcc77e924c34e6d8b8a0142bf7198fe8c32cab8af5ba4bab
check 1 hS580Ghp0Jc8l2dwdI
check 2 zhS580Ghp0Jc8l2dwdI!
check 3 ahS580Ghp0J!
check 4 hS580Ghp0Jc8


echo "Test passed!"

exit 0
