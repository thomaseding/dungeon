# If not running interactively, don't do anything
[[ $- != *i* ]] && return


export TERM='xterm-256color'

export PATH="$HOME/bin:$PATH:$HOME/.cabal/bin"

export TMP="$HOME/tmp"

export TAB_AMOUNT=4

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
    local PROMPT="\n$(date "+%I:%M%P") ${PWD}\n${HOSTNAME}:${USER}$(promptchar)"
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
    export TS3D="$HOME/ts3d"
    export HMF_MASTER="$TS3D/hmf_master"
    export VISUALIZE="$TS3D/visualize"
    export SANITY="$VISUALIZE/master/hoops_3df/demo/common/sanity"
    export CGS="$VISUALIZE/master/internal_tools/support/code_gen/cgs"
    if [ "$OSTYPE" != 'darwin12' ]
    then
	xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'
    fi
fi


alias v="vim"
alias vi="vim"
alias figlet="figlet -t"
alias ls="ls -FhHx"
alias ll="ls -lA"
alias la="ls -A"
alias l.="ll | egrep ' \.\w'"
alias log="git log | less -e"
alias su="su -l"
alias sudo="sudo " # so aliases work with sudo


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


issue () {
    cd "$ISSUES/$1"
}


storedir () {
    pwd > ~/mycookies/dir-store
}


restoredir () {
    cd `cat ~/mycookies/dir-store`
}


dungeon () {
    local ORIG_DIR=`pwd`
    cd "$HOME/dungeon/$1"
    ls src &> /dev/null && cd src
    OLDPWD="$ORIG_DIR"
    ls
}


code () {
    local ORIG_DIR=`pwd`
    cd "$HOME/code/$1"
    ls src &> /dev/null && cd src
    OLDPWD="$ORIG_DIR"
    ls
}


visualize () {
    cd "$VISUALIZE/$1"
    ls
}


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


setlinux () {
    export LD_LIBRARY_PATH=".:../../Dev_Tools/hoops_3dgs/lib/linux/:/usr/local/qt/lib"
}
export -f setlinux

setlinux_x86_64 () {
    export LD_LIBRARY_PATH=".:../../Dev_Tools/hoops_3dgs/lib/linux_x86_64/:/usr/local/qt/lib"
}
export -f setlinux_x86_64


alias smokegrind="valgrind --smc-check=all --leak-check=full --num-callers=30 ./smoke.exe -H hzb -s -e -P -U -d opengl"






