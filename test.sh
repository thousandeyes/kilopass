#!/bin/sh

KP=./kilopass.sh

fail() {
	echo $* 1>&2
	exit 1
}

check() {
	$KP -s salty -g $1 peppery | grep ^$2$ || fail "Generation mode $1 did not output $2."
}

echo "Output is going to look pretty weird for a bit. It's expected."

$KP && fail "Should return zero."
$KP -h || fail "Help should return one."
$KP -s salty && fail "kilopass without target argument or help should not return 0."
$KP -s salty peppery | grep '^hS580Ghp0Jc8l2dwdI$' || fail "Default salty peppery failed."
check 0 8733c96b306a12f7fcc77e924c34e6d8b8a0142bf7198fe8c32cab8af5ba4bab
check 1 hS580Ghp0Jc8l2dwdI
check 2 zhS580Ghp0Jc8l2dwdI!
check 3 ahS580Ghp0J!
check 4 hS580Ghp0Jc8
check 5 hS580Ghp


echo "Test passed!"

exit 0
