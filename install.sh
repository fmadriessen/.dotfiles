#! /usr/bin/env bash

PROG_LIST=(
	neovim
	kitty
	fish

	# CLI Utils
	bat
	ripgrep
	hyperfine
	fzf
	fd

	# LSPs, formatters, and linters
	bash-language-server
	shellcheck
	shfmt
	shellharden

	lua-language-server
	selene
	stylua
)

link() {
	echo "Symlinking files into XDG_CONFIG_HOME"
	export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
	test -d "$XDG_CONFIG_HOME" || mkdir -pv "$XDG_CONFIG_HOME"

	for source in xdg_config/*; do
		dest="$XDG_CONFIG_HOME/${source#*/}"
		if [ -e "$dest" ]; then
			echo "$dest already exists: not linking $source"
			continue
		fi

		echo "Linking $source to $dest"
		ln -sf "$PWD/$source" "$dest"
	done
}

install() {
	echo "Installing programs"
	case $(uname) in
	Darwin)
		hash brew || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		brew install "${PROG_LIST[@]}"
		;;
	Linux)
		case $(grep "^ID=" /etc/os-release | sed 's/^ID=//') in
		arch) pkexec pacman -S "${PROG_LIST[@]}" ;;
		*)
			echo "Unrecognized Linux distribution"
			exit 1
			;;
		esac
		;;
	*)
		echo "Unrecognized OS"
		exit 1
		;;
	esac
}

# Argument handling
if [ $# -lt 1 ]; then
	link
	echo
	install
else
	case $1 in
	install) install ;;
	link) link ;;
	*)
		echo "Not a recognized command: $1"
		exit 1
		;;
	esac
fi
