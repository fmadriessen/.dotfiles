#! /usr/bin/env sh

if [ "$TERM" = "xterm-kitty" ]; then
	kitty +kitten icat --clear --silent --transfer-mode file
fi
