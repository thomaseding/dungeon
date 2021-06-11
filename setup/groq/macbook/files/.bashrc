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

set -u # This causes error when reading unset env variable instead of silent progression.
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

pause-enter () {
  read -p 'Press ENTER to continue...'
}

pause-any () {
  read -n 1 -s -r -p 'Press any key to continue...'
}

pause () {
  pause-enter
}

notify () {
  local MESSAGE=$1
  local SCRIPT='display notification "'$MESSAGE'"'
  if [ "$#" -eq "2" ]
  then
    local TITLE=$2
    local SCRIPT=$SCRIPT' with title "'$TITLE'"'
  fi
  osascript -e "$SCRIPT"
}

play-sound () {
  afplay /System/Library/Sounds/Hero.aiff
}

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

lolcat_seed=$RANDOM

promptcommand () {
	let lolcat_seed++
  local xcode=$(xcode-sdk)
	local differs=''
	local branch=''
  if inside-git-repo
  then
    local differs=$(git-differs && echo '*')
    local branch=" ($(git-branch))"
  fi
	local prompt="$(date "+%I:%M%p") ${PWD}\n${xcode}:${USER}${branch}${differs}$(prompt-char)"
	local color_prompt=$(echo -e $prompt | lolcat --seed $lolcat_seed --force --spread 3 --freq 0.3 | ansi2prompt --bash | ghead -c-9)
	export PS1="\n$color_prompt\[\033[0m\] "
}

export PROMPT_COMMAND=promptcommand

g() {
  local dest=$(up "$@")
  if [ "$?" == '0' ]
  then
    cd "$dest"
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
  local repo=$1
  local dir=$2
  git clone --recurse-submodules $repo $dir --depth=1
  cd $dir
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
  if [ "$#" -ne 1 ]
  then
    echo "Illegal number of parameters"
  fi
  local dir=`realpath "$1"`
	local needle='artifacts'
	if [[ "$dir" == *"/$needle" || "$dir" == *"/$needle/"* ]]
	then
		local files="$dir/*"
    local file
		for file in $files
		do
			rm -rf $file
		done
	else
		echo "clean: Not inside '$needle' directory structure"
	fi
}


tokenize()
{
	local first=1
	echo -n '['
  local var
	for var in "$@"
	do
		local var=`echo -n "$var" | sed 's/"/\\\\"/g'`
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




