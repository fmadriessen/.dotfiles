#! /usr/bin/env bash

# Detect file extension/type and suitably preview the file on the commandline
# Intended for usage with the LF file manager
# By default this file is invoked with the following arguments
# `previewer $file $width $heigth $left_offset $top_offset`

file="$1"
width="$2"
height="$3"
left="$4"
top="$5"

IMG_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/lf/thumbnail.$(stat --printf '%n\0%i\0%F\0%s\0%W\0%Y' -- "$(readlink -f "$file")" | sha256sum | awk '{print $1}'))"

view_img() {
	case "$TERM" in
	xterm-kitty)
		kitty +kitten icat --place="$width"x"$height"@"$left"x"$top" --transfer-mode=file --silent "$1"
		;;
	*)
		chafa --size="$width"x"$height" "$1"
		;;
	esac
}

view_text() {
	bat --terminal-width="$width" --plain --color=always "$1"
}

shopt -s extglob
case "$file" in
*.epub)
	test -f "$IMG_CACHE" || gnome-epub-thumbnailer "$file" "$IMG_CACHE"
	view_img "$IMG_CACHE"
	;;
*.@(md|markdown))
	glow --style dark --width "$width" "$file"
	;;
*.tar.gz)
	tar --gzip -tvf "$file" | awk '{print substr($0, index($0, $6))}'
	;;
*)
	case "$(file --brief --mime-type --dereference -- "$file")" in
	image/*)
		view_img "$file"
		;;
	video/*)
		test -f "$IMG_CACHE" || ffmpegthumbnailer -i "$file" -o "$IMG_CACHE" -s 0 -c png -m
		view_img "$IMG_CACHE"
		;;
	text/*)
		view_text "$file"
		;;
	application/json)
		view_text "$file"
		;;
	application/pdf)
		test -f "$IMG_CACHE" || pdftoppm -q -f 1 -l 1 \
			-singlefile \
			-png \
			-- "$file" "$IMG_CACHE"
		view_img "$IMG_CACHE.png"
		;;
	application/zip)
		unzip -lqq "$file" | awk '{print substr($0, index($0, $4))}'
		;;
	*) ;;

	esac
	;;
esac

exit 1
