# If not running interactively, don't do anything
[[ $- != *i* ]] && return


set -o vi

export HOOPS_WERROR="-Werror -Wno-unused-result"



if [ "${HOSTNAME%.local}" == 'warden' ]
then
	export EDITOR="/usr/local/Cellar/macvim/<version>/bin/mvim"
fi

export TERM='xterm-256color'

export PATH="$HOME/bin:$PATH:$HOME/.cabal/bin"

export TMP="$HOME/tmp"

export TAB_AMOUNT=4

export GHC_EXTENSIONS="-XRank2Types -XExistentialQuantification -XTemplateHaskell -XQuasiQuotes -XFunctionalDependencies -XStandaloneDeriving -XGADTs -XTupleSections -XFlexibleInstances -XFlexibleContexts -XViewPatterns -XMultiParamTypeClasses -XGeneralizedNewtypeDeriving -XEmptyDataDecls -XTypeFamilies -XConstraintKinds"

LOLCAT_SEED=$RANDOM

promptchar () {
    if [ `id -u` == '0' ]
    then
		echo -n '#'
    else
		echo -n '$'
    fi
}

promptcommand () {
    let LOLCAT_SEED++
	local HDRM=$(test ${HOOPS_DEBUG_RAW_MEMORY-0} == 1 && echo "[hdrm]")
	local DIFFERS="" #$(git branch &> /dev/null && (git diff HEAD --quiet || echo "*"))
	local BRANCH=$(git branch &> /dev/null && echo " (${DIFFERS}$(git rev-parse --abbrev-ref HEAD))")
    local PROMPT="\n$(date "+%I:%M%P") ${PWD}\n${HOSTNAME}:${USER}${BRANCH}${HDRM}$(promptchar)"
    local COLOR_PROMPT=$(echo -en $PROMPT | lolcat --seed $LOLCAT_SEED --force --spread 3 --freq 0.3 | substr 0 -1 | ansi2prompt)
    export PS1="$COLOR_PROMPT "
    export COLUMNS
}

export PROMPT_COMMAND=promptcommand


if [ "$TERM" == 'cygwin' ]
then
    alias vim="cyg-wrapper.sh vim"
    #cd $USERPROFILE
else
    export TECHSOFT3D="$HOME/techsoft3d"
    export HMF_MASTER="$TECHSOFT3D/hmf_master"
    export VISUALIZE="$TECHSOFT3D/visualize"
	export ISSUES="$TECHSOFT3D/issues"
    export SANITY="$VISUALIZE/master/hoops_3df/demo/common/sanity"
	export SMOKE_DATA="$TECHSOFT3D/smoke-data"
    export CGS="$VISUALIZE/master/internal_tools/support/code_gen/cgs"
	export HEXCHANGE_INSTALL_DIR="$TECHSOFT3D/exchange/HOOPS_Exchange_700"
    if [ "$OSTYPE" != 'darwin12' ]
    then
		xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'
    fi
fi


alias vim="mvim -v"
alias v="vi"
alias vimhelp="vim -c ':help window' -c ':only'"
alias figlet="figlet -t"
alias ls="ls -FhHx"
alias ll="ls -lA"
alias la="ls -A"
alias l.="ll | egrep ' \.\w'"
alias log="git log | less -e"
alias su="su -l"
alias sudo="sudo " # so aliases work with sudo
alias mws="wine $HOME/.wine/drive_c/Program\ Files/Magic\ Workstation/MagicWorkstation.exe"
alias ghci="ghci $GHC_EXTENSIONS"


g () {
    local DEST
    DEST=$(up "$@")
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


foreach () {
    local CMD=$1
    shift
    for arg in "$@" ; do
		$CMD $arg
    done
}


path () {
    echo "$PATH" | tr ':' '\n'
}


issue () {
    cd "$ISSUES/$1"
}
_issue () {
	if [ "$COMP_CWORD" == "1" ]
	then
		local cur="${COMP_WORDS[COMP_CWORD]}"
		local dirs="$(ls -1 $ISSUES | grep '/$')"
		COMPREPLY=( $(compgen -W "$dirs" -- $cur) )
	fi
}
complete -F _issue issue


storedir () {
    pwd > "$HOME/mycookies/dir-store"
}


restoredir () {
    cd $(cat "$HOME/mycookies/dir-store")
}
_restoredir () {
	if [ "$COMP_CWORD" == "1" ]
	then
		local cur="${COMP_WORDS[COMP_CWORD]}"
		local dir=$(cat "$HOME/mycookies/dir-store")
		COMPREPLY=( $(compgen -W "$dir" -- $cur) )
	fi
}
complete -F _restoredir restoredir


dungeon () {
    local ORIG_DIR=`pwd`
    cd "$HOME/dungeon/$1"
    ls src &> /dev/null && cd src
    OLDPWD="$ORIG_DIR"
    ls
}
_dungeon () {
	if [ "$COMP_CWORD" == "1" ]
	then
		local cur="${COMP_WORDS[COMP_CWORD]}"
		local dirs="$(ls -1 $HOME/dungeon | grep '/$')"
		COMPREPLY=( $(compgen -W "$dirs" -- $cur) )
	fi
}
complete -F _dungeon dungeon


code () {
    local ORIG_DIR=`pwd`
    cd "$HOME/code/$1"
    ls src &> /dev/null && cd src
    OLDPWD="$ORIG_DIR"
    ls
}
_code () {
	if [ "$COMP_CWORD" == "1" ]
	then
		local cur="${COMP_WORDS[COMP_CWORD]}"
		local dirs="$(ls -1 $HOME/code | grep '/$')"
		COMPREPLY=( $(compgen -W "$dirs" -- $cur) )
	fi
}
complete -F _code code


visualize () {
    cd "$VISUALIZE/$1"
    ls
}
_visualize () {
	if [ "$COMP_CWORD" == "1" ]
	then
		local cur="${COMP_WORDS[COMP_CWORD]}"
		local dirs="$(ls -1 $VISUALIZE | grep '/$')"
		COMPREPLY=( $(compgen -W "$dirs" -- $cur) )
	fi
}
complete -F _visualize visualize


sanity () {
    if [ "$1" == '' ]
    then
		ls hoops_3df &> /dev/null && cd hoops_3df
		local ORIG_DIR=`pwd`
		local BACKUP_DIR="$ORIG_DIR"

		g hps
		if [ "$?" == '0' ]
		then
			cd ../hoops_3df
			local BACKUP_DIR=`pwd`
		fi

		g internal_tools
		if [ "$?" == '0' ]
		then
			cd ../hoops_3df
			local BACKUP_DIR=`pwd`
		fi

		g visualize
		if [ "$?" == '0' ]
		then
			cd "$BACKUP_DIR"
			g hoops_3df
			cd demo/common/sanity
		else
			cd "$SANITY"
		fi

		OLDPWD="$ORIG_DIR"
	else
		cd "$VISUALIZE/$1/hoops_3df/demo/common/sanity"
    fi
}
_sanity () {
	if [ "$COMP_CWORD" == "1" ]
	then
		local cur="${COMP_WORDS[COMP_CWORD]}"
		local dirs="$(ls -1 $VISUALIZE | grep '/$')"
		COMPREPLY=( $(compgen -W "$dirs" -- $cur) )
	fi
}
complete -F _sanity sanity


setlinux () {
    export LD_LIBRARY_PATH=".:../../Dev_Tools/hoops_3dgs/lib/linux/:/usr/local/qt/lib"
}
export -f setlinux

setlinux_x86_64 () {
    export LD_LIBRARY_PATH=".:../../Dev_Tools/hoops_3dgs/lib/linux_x86_64/:/usr/local/qt/lib"
}
export -f setlinux_x86_64


alias smokegrind="valgrind --smc-check=all --leak-check=full --num-callers=30 ./smoke.exe -H hzb -s -e -P -U"


movedown () {
	mv "$1" ../"$1"
}



