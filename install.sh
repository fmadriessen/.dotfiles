#! /usr/bin/env sh

# Set some things depending on the OS
case $(uname) in
Darwin)
	hash brew || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	PKG_MANAGER="brew install"
	;;
Linux)
	case $(grep "^ID=" /etc/os-release | sed 's/^ID=//') in
	arch) PKG_MANAGER="pkexec pacman -S" ;;
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

link() {
	echo "Symlinking files into XDG_CONFIG_HOME"
	export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
	test -d "$XDG_CONFIG_HOME" || mkdir -pv "$XDG_CONFIG_HOME"

	MODULES="nvim kitty bat git"
	for module in $MODULES; do
		if [ -e "$XDG_CONFIG_HOME/$module" ]; then
			echo "$module already exists in $XDG_CONFIG_HOME: not linking $module"
			continue
		fi

		ln -sf "$PWD/xdg_config/$module" "$XDG_CONFIG_HOME/$module"
	done
}

install() {
	echo "Installing programs"
	UTILS="neovim kitty bat ripgrep hyperfine fish fzf fd"
	LSPS="bash-language-server lua-language-server"
	"$PKG_MANAGER" "$UTILS" "$LSPS"
}

# Argument handling
if [ $# -lt 1 ]; then
	link
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
