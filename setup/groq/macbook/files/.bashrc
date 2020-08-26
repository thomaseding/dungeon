export BASH_SILENCE_DEPRECATION_WARNING=1
export HISTCONTROL=ignoreboth # dont write history for duplicate commands and commands beginning with space

[ -f "/Users/thomaseding/.ghcup/env" ] && source "/Users/thomaseding/.ghcup/env" # ghcup-env

#PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
PATH="/usr/local/opt/coreutils/bin:$PATH"
PATH="$HOME/Library/Haskell/bin:$PATH"
export PATH

function ssh () {
	/usr/bin/ssh -t $@ "tmux attach || tmux new";
}

set -u # Error when reading unset env variable
set -o vi

LS_COLORS="ln=00;36:di=00;32:fi=00;90:no=00;91"
export LS_COLORS

alias realpath=grealpath

# some more ls aliases
alias ls='gls --color=auto'
alias ll='ls -AlFv --group-directories-first'
alias la='ls -A'
alias l='ls -CF'

alias v='vi'

export CODE="$HOME/code"

alias ansi2prompt="$CODE/ansi2prompt/build/Main"

promptchar () {
    if [ `id -u` == '0' ]
    then
		echo -n '#'
    else
		echo -n '$'
    fi
}

LOLCAT_SEED=$RANDOM

promptcommand () {
	let LOLCAT_SEED++
	local DIFFERS="" #$(git branch &> /dev/null && (git diff HEAD --quiet || echo "*"))
	local BRANCH=$(git branch &> /dev/null && echo " (${DIFFERS}$(git rev-parse --abbrev-ref HEAD))")
	local COMP_NAME=${HOSTNAME%.local}
	local PROMPT="$(date "+%I:%M%P") ${PWD}\n${COMP_NAME}:${USER}${BRANCH}$(promptchar)"
	local COLOR_PROMPT=$(echo -e $PROMPT | lolcat --seed $LOLCAT_SEED --force --spread 3 --freq 0.3 | ansi2prompt --bash | ghead -c-9)
	export PS1="\n$COLOR_PROMPT\[\033[0m\] "
}

export PROMPT_COMMAND=promptcommand


git_incremental_clone()
{
    REPO=$1
    DIR=$2
    git clone --recurse-submodules $REPO $DIR --depth=1
    cd $DIR
    git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
    git fetch --depth=10
    git fetch --depth=100
    git fetch --depth=1000
    git fetch --depth=10000
    git fetch --depth=100000
    git fetch --depth=1000000
    git pull
}


# Commands to run when shell opens:
#clear
#ll

