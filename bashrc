# If not running interactively, don't do anything
[[ $- != *i* ]] && return


export TERM='xterm-256color'

export PATH=$PATH:~/.cabal/bin

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
    export VISUALIZE="$HOME/ts3d/visualize"
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
    cd `up "$@"`
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
    ls hoops_3df &> /dev/null && cd hoops_3df
    local ORIG_DIR=`pwd`
    local BACKUP_DIR="$ORIG_DIR"

    g hps
    if [ `pwd` == '/' ]
    then
	cd "$BACKUP_DIR"
    else
	cd ../hoops_3df
	local BACKUP_DIR=`pwd`
    fi

    g internal_tools
    if [ `pwd` == '/' ]
    then
	cd "$BACKUP_DIR"
    else
	cd ../hoops_3df
	local BACKUP_DIR=`pwd`
    fi

    g visualize
    if [ `pwd` == '/' ]
    then
	cd "$SANITY"
    else
	cd "$BACKUP_DIR"
	g hoops_3df
	cd demo/common/sanity
    fi
    OLDPWD="$ORIG_DIR"
}











