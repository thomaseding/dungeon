THOMAS=/Users/thomaseding # Not using $HOME to play nice with root login.

bind 'set mark-symlinked-directories on'

export BASH_SILENCE_DEPRECATION_WARNING=1
export HISTCONTROL=ignoreboth # dont write history for duplicate commands and commands beginning with space

[ -f "/Users/thomaseding/.ghcup/env" ] && source "/Users/thomaseding/.ghcup/env" # ghcup-env

export GOPATH="$HOME/.go"

#PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
PATH="/Users/thomaseding/work/repos/3rd-party/arcanist/bin:$PATH"
PATH="/usr/local/opt/coreutils/bin:$PATH"
PATH="$THOMAS/Library/Haskell/bin:$PATH"
PATH="$PATH:$(go env GOPATH)/bin"
PATH="/Users/thomaseding/work/repos/3rd-party/depot_tools:$PATH"
export PATH

export EDITOR=vim
export VISUAL=$EDITOR
export GIT_EDITOR=$EDITOR

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

xcode-sdk () {
  xcode-select -p | perl -pe 's|^.*/([^/]+)/Xcode.app/.*$|$1|'
}

inside-git-repo () {
  git rev-parse --is-inside-work-tree > /dev/null 2>&1
}

git-differs () {
	! git diff HEAD --quiet > /dev/null 2>&1
}

git-branch () {
	git rev-parse --abbrev-ref HEAD
}

is-root () {
  [ `id -u` == '0' ]
}

prompt-char () {
  is-root && echo -n '#' || echo -n '$'
}

LOLCAT_SEED=$RANDOM

promptcommand () {
	let LOLCAT_SEED++
  local XCODE=$(xcode-sdk)
	local DIFFERS=''
	local BRANCH=''
  if inside-git-repo
  then
    local DIFFERS=$(git-differs && echo '*')
    local BRANCH=" ($(git-branch))"
  fi
	local PROMPT="$(date "+%I:%M%p") ${PWD}\n${XCODE}:${USER}${BRANCH}${DIFFERS}$(prompt-char)"
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


cherry-server()
{
	cd $HOME/work/repos/3rd-party/cherry
	go run server.go
}




