
PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
PATH="$HOME/Library/Haskell/bin:$PATH"
export PATH

function ssh () {
	/usr/bin/ssh -t $@ "tmux attach || tmux new";
}

set -o vi

LS_COLORS="ln=00;36:di=00;32:fi=00;90:no=00;91"
export LS_COLORS

# some more ls aliases
alias ls='ls --color=auto'
alias ll='ls -AlFv --group-directories-first'
alias la='ls -A'
alias l='ls -CF'

alias v='vi'

alias ansi2prompt='/Users/teding/code/ansi2prompt/dist-newstyle/build/x86_64-osx/ghc-8.6.3/ansi2prompt-0.1.0.1/x/ansi2prompt/build/ansi2prompt/ansi2prompt'

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
	local PROMPT="$(date "+%I:%M%P") ${PWD}\n ${COMP_NAME}:${USER}${BRANCH}$(promptchar)"
	local COLOR_PROMPT=$(echo -e $PROMPT | lolcat --seed $LOLCAT_SEED --force --spread 3 --freq 0.3 | ansi2prompt --bash)
	export PS1="\n$COLOR_PROMPT\[\033[0m\] "
}

export PROMPT_COMMAND=promptcommand

# Commands to run when shell opens:
clear
ll

