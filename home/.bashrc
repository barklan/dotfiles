#
# ~/.bashrc
#

# INFO: Make sure this line is in ~/.bash_profile
# [[ -f ~/.bashrc ]] && . ~/.bashrc

export PATH="/home/barklan/.local/bin:$PATH"
export PATH="/home/barklan/go/bin:$PATH"
export PATH="/home/barklan/.cargo/bin:$PATH"
export PATH="/home/barklan/sys/bin:$PATH"

if [[ "$TERM_PROGRAM" == "vscode" ]]; then
	export EDITOR="code"
fi

export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus

export DOCKER_BUILDKIT=1

export npm_config_prefix="$HOME/.local"

if [ "$XDG_SESSION_TYPE" == "wayland" ]; then
	export MOZ_ENABLE_WAYLAND=1
fi

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export QT_QPA_PLATFORM="wayland;xcb"
export RUSTC_WRAPPER=sccache
export CARGO_REGISTRIES_CRATES_IO_PROTOCOL=sparse
export LIBVA_DRIVER_NAME=iHD
export GOGC=200
export BROWSER=firefox-developer-edition
export EDITOR="nvim"
export VISUAL="nvim"
export GIT_EDITOR="nvim"
export GIT_PAGER='delta'
export BAT_THEME=Coldark-Dark
export KUBECONFIG=${HOME?}/.kube/config
export OS=Linux
export ELECTRON_OZONE_PLATFORM_HINT=auto
export DISTRIB_ID=$(lsb_release -i | awk '{print $3}')

# NOTE: no idea what these do exactly
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_ENABLE_HIGHDPI_SCALING=1

export DIFFPROG='code --wait --diff'

export GOAMD64=v3
export RUSTFLAGS="-C target-cpu=native"

# WARN: below is interactive only
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls -lav --ignore=..' # show long listing of all except ".."
alias l='ls -lav --ignore=.?*' # show long listing but no hidden dotfiles except "."

[[ "$(whoami)" = "root" ]] && return

[[ -z "$FUNCNEST" ]] && export FUNCNEST=100 # limits recursive functions, see 'man bash'

# THE REST OF THE STUFF
shopt -s histappend
shopt -s cmdhist

export HISTSIZE=50000
export HISTFILESIZE=50000
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE="rm *:#*:sudo rm *"

export GPG_TTY=$(tty)
gpgconf --launch gpg-agent

export PS1="\[\033[38;5;5m\]\W \[$(tput bold)\]\$? \\$\[$(tput sgr0)\] \[$(tput sgr0)\]"

export FORGIT_NO_ALIASES=true

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

if [[ $(ps --no-header --pid="$PPID" --format=comm) != "fish" && -z $BASH_EXECUTION_STRING ]]; then
	# fish && exit
	exec fish
fi
