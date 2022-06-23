# PATHS
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_STATE_HOME $HOME/.local/state

set -gx GOPATH $XDG_DATA_HOME/go
set -gx CARGO_HOME $XDG_DATA_HOME/cargo
set -gx RUSTUP_HOME $XDG_DATA_HOME/rustup

set -gx TEXMFHOME $XDG_DATA_HOME/texmf
set -gx TEXMFVAR $XDG_CACHE_HOME/texlive/texmf-var
set -gx TEXMFCONFIG $XDG_CONFIG_HOME/texlive/texmf-config

set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx PAGER less
set -gx MANPAGER "nvim +Man!"

# Default options for less
set -x LESS "--RAW-CONTROL-CHARS --quit-if-one-screen --ignore-case"
set -x LESSHISTFILE $XDG_CACHE_HOME/lesshst

if status is-interactive
    set -g fish_greeting

    fish_add_path ~/scripts

    alias edit $EDITOR
    alias view bat
    alias diff delta

    fish_vi_key_bindings
    fzf_key_bindings
    bind -M insert \cp complete-and-search
    bind -M insert \cn complete

    bind -M insert \ce suppress-autosuggestion
    bind -M insert \cy accept-autosuggestion

    bind -M insert \ck history-search-backward
    bind -M insert \cj history-search-forward

    # FZF
    set -gx FZF_DEFAULT_COMMAND "fd --type f --hidden --follow --strip-cwd-prefix --exclude .git"
    set -gx FZF_DEFAULT_OPTS "--color=16 --height 40% --layout=reverse --border=horizontal --bind '?:toggle-preview' --bind 'ctrl-d:preview-half-page-down' --bind 'ctrl-u:preview-half-page-up' --filepath-word --marker=🞄"
    set -gx FZF_CTRL_T_COMMAND "fd --hidden --follow --strip-cwd-prefix --exclude .git \$dir"
    set -gx FZF_CTRL_T_OPTS "--select-1 --exit-0 --preview 'fish -c \"command bat --color=always --style plain {} || command tree -C {}\" 2>/dev/null' --preview-window=border-left"
    set -gx FZF_CTRL_R_OPTS "--preview 'echo {}' --preview-window down:hidden:wrap"
    set -gx FZF_ALT_C_COMMAND "fd --type directory --hidden --follow --strip-cwd-prefix --exclude .git \$dir"
    set -gx FZF_ALT_C_OPTS "--select-1 --exit-0 --preview 'command tree -C {}' --preview-window=border-left"

    # Initialize zoxide
    zoxide init fish | source
end
