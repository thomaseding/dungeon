# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000
HISTIGNORE='exit'

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
  # We have color support; assume it's compliant with Ecma-48
  # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
  # a case would tend to support setf rather than setaf.)
  color_prompt=yes
    else
  color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

export VISUAL=vim
export EDITOR="$VISUAL"
export GROQ="/home/teding/work/repos/Groq"
export GROQ_UNITY_BUILD=0

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias less='less -SRc'
alias tb='tensorboard --logdir=/home/teding/tensorboard-workspace --reload_interval=2'

bghci () {
  local common_flags='-Werror -Wall -Wincomplete-uni-patterns'

  if [ -z "$update" ]
  then
    bake update ghci --current
  fi

  if [ -z "$typecheck" ]
  then
    new_update=t bake ghci $common_flags -fobject-code "$@"
  else
    new_update=t bake ghci $common_flags "$@"
  fi
}

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

set -o vi

LS_COLORS="ln=00;36:di=00;32:fi=00;90:no=00;91"
export LS_COLORS

# some more ls aliases
alias ll='ls -AlFv --group-directories-first'
alias la='ls -A'
alias l='ls -CF'

unset SFT_AUTH_SOCK

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export PATH="$PATH:/home/teding/.pyenv/bin:/home/teding/.cabal/bin"

#export VIM=/usr/share/vim/vim74

alias ansi2prompt='~/code/ansi2prompt/build/Main'
alias substr='~/code/substr/build/Main'
alias up='~/code/up/build/Main'

ANSI2PROMPT="$HOME/code/ansi2prompt/build/Main"

#cabal new-configure && cabal new-build && cabal new-haddock --haddock-for-hackage && cabal new-sdist
#alias cabal-build-hackage='cabal new-configure && cabal new-build && cabal new-haddock --haddock-for-hackage && cabal new-sdist'
#alias cabal-build-clean='xxxxxxxxx'

promptchar () {
    if [ `id -u` == '0' ]
    then
      echo -n '#'
    else
      echo -n '$'
    fi
}

PROMPT_GIT_BRANCH_LEN=34

LOLCAT_SEED=$RANDOM

promptcommand () {
  let LOLCAT_SEED++
  local DIFFERS="" #$(git branch &> /dev/null && (git diff HEAD --quiet || echo "*"))
  local BRANCH=$(git branch &> /dev/null && echo " (${DIFFERS}$(git rev-parse --abbrev-ref HEAD | substr --elipsis 0 $PROMPT_GIT_BRANCH_LEN))")
  local PROMPT="$(date "+%I:%M%P") ${PWD}\n(ssh) ${BRANCH}$(promptchar)"
  local COLOR_PROMPT=$(echo -en $PROMPT | lolcat --seed $LOLCAT_SEED --force --spread 3 --freq 0.3 | $ANSI2PROMPT --bash | substr 0 -8)
  local COLOR_PROMPT=$(echo -en $PROMPT | lolcat --seed $LOLCAT_SEED --force --spread 3 --freq 0.3 | $ANSI2PROMPT --bash)
  export PS1="\n$COLOR_PROMPT\[\033[0m\] "
}

#export PROMPT_COMMAND=promptcommand

g () {
  local DEST
  DEST=$(up --from-to $PWD "$@")
  if [ "$?" == '0' ]
  then
    cd "$DEST"
  else
    return "$?"
  fi
}
_g () {
  if [ "$COMP_CWORD" == "1" ]
  then
    local cur=${COMP_WORDS[COMP_CWORD]}
    local parts="$(pwd | tr '/' ' ')"
    COMPREPLY=( $(compgen -W "$parts" -- $cur) )
  fi
}
complete -F _g g

groq () {
	cd /home/teding/work/repos/Groq
}

api () {
	cd /home/teding/work/repos/Groq/GroqAPI
}

pane () {
	local name=$1
	tmux new -s $name
  if [ "$?" != '0' ]
  then
		tmux a -t $name
	fi
}

findpp () {
  find . -path "*/$1"
}

#alias v='vi'
#alias vimlauncher='runghc ~/code/vim-launcher/src/VimLauncher.hs'
v () {
  ARGS=$(vimlauncher "$@")
  if [ "$?" == '0' ]
  then
    vim $ARGS
  else
    echo "$ARGS" # https://stackoverflow.com/questions/16535886/maintain-line-breaks-in-output-from-subshell
    return "$?"
  fi
}

# Commands to run when shell opens:
set -o ignoreeof
[[ "$PWD" == "$HOME" ]] && (cd ~/groq ; clear ; ll)

#eval "$(pyenv init -)"
#eval "$(pyenv virtualenv-init -)"

test -f ~/.git-completion.bash && . $_
source /nix/var/nix/profiles/default/config/bash/bake-completion.bash

export BAKE_BUILDER=groqnode96.lab.groq.com


