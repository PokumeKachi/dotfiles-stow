[[ $- != *i* ]] && return

if [[ $EUID -eq 0 ]]; then
    PS1='\[\e[1;40;94m\]\u\[\e[1;40;93m\]:\w\[\e[1;91m\]\$\[\e[0m\] '
else
    PS1='\[\e[1;32m\]\u\[\e[0m\]:\[\e[1;34m\]\w\[\e[1;35m\]\$\[\e[0m\] '
fi

# if [[ -z "$TMUX" ]]; then
# [[ -z "$TMUX" ]] && tmux

# fi

# Commands that should be applied only for interactive shells.
[[ $- == *i* ]] || return

HISTFILESIZE=100000
HISTSIZE=10000

shopt -s histappend
shopt -s extglob
shopt -s globstar
shopt -s checkjobs

if [[ ! -v BASH_COMPLETION_VERSINFO ]]; then
    . "/nix/store/0sl23ayhi8bxylgxvlpxsk5yqn40hjad-bash-completion-2.17.0/etc/profile.d/bash_completion.sh"
fi

# if [[ $(/nix/store/v5lx2zmgp754ci64ln3m9f4j8bhvbgps-procps-4.0.4/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ${BASH_EXECUTION_STRING} ]]
# then
#   shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
#   exec /nix/store/fbb07rx324bpscfzzkg05diw70igbfvk-fish-4.2.1/bin/fish $LOGIN_OPTION
# fi

function yy() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(<"$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

if test -n "$KITTY_INSTALLATION_DIR"; then
    export KITTY_SHELL_INTEGRATION="no-rc no-cursor"
    source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"
fi

eval "$(/nix/store/wpj4la1jgf0p8aimfzx49gfr3228vk8f-direnv-2.37.1/bin/direnv hook bash)"

eval "$(/nix/store/5g10iizw7yacs5kr8s7l3v6hirjw9i15-zoxide-0.9.8/bin/zoxide init bash)"
