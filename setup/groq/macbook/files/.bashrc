THOMAS=/Users/thomaseding # Not using HOME to play nice with root login.

export BASH_SILENCE_DEPRECATION_WARNING=1
export HISTCONTROL=ignoreboth # dont write history for duplicate commands and commands beginning with space

[ -f "/Users/thomaseding/.ghcup/env" ] && source "/Users/thomaseding/.ghcup/env" # ghcup-env

#PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
PATH="/usr/local/opt/coreutils/bin:$PATH"
PATH="$THOMAS/Library/Haskell/bin:$PATH"
export PATH

function ssh () {
	/usr/bin/ssh -t $@ "tmux attach || tmux new";
}

complete -cf sudo
. $THOMAS/.git-completion.bash

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

alias clang-format='xcrun clang-format'

export CODE="$THOMAS/code"

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

g() {
    local DEST
    DEST=$(up "$@")
    if [ "$?" == '0' ]
    then
        cd "$DEST"
    else
        return "$?"
    fi
}

_g() {
    if [ "$COMP_CWORD" == "1" ]
    then
        local cur=${COMP_WORDS[COMP_CWORD]}
        local parts="$(pwd | tr '/' ' ')"
        COMPREPLY=( $(compgen -W "$parts" -- $cur) )
    fi
}
complete -F _g g

git_incremental_clon()
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


clean()
{
	NEEDLE='artifacts'
	if [[ $PWD == *"/$NEEDLE" || $PWD == *"/$NEEDLE/"* ]];
	then
		files=`ls -A`
		for file in $files
		do
			rm -rf $file
		done
	else
		echo "clean: Not inside '$NEEDLE' directory structure"
	fi
}


tokenize()
{
	first=1
	echo -n '['
	for var in "$@"
	do
		var=`echo -n "$var" | sed 's/"/\\\\"/g'`
		if [ $first == '1' ]
		then
			first=0
		else
			echo -n ', '
		fi
		echo -n '"'
		echo -n "$var"
		echo -n '"'
	done
	echo -n ']'
}






