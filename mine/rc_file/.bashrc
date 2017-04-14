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

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

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

function cpick
{
	local cpick_commit="cpick_commit.tmp"
	local cpick_tmp="cpick_tmp.tmp"
	local cpick_is_error="cpick_is_error.tmp"
    
	OPTIND=0
	while getopts :h opt
	do
		case $opt in
			h)  echo "Usage: cpick [-h] [branchA branchB]"
				return
				;;
			?)	echo "Invalid option, use -h to see usage"
				return
				;;
		esac
	done
	shift $((OPTIND - 1))

	echo 0 > $cpick_is_error
# three argvs, two possible
# 1. new pick -> execute flow
# 2. old pick not complete -> do nothing
	if [ $# -eq 2 ];then
		if [ ! -e $cpick_commit ];then
			git cherry -v $1 $2 > $cpick_commit
			if [ $? -ne 0 ];then
				rm cpick*.tmp
				return
			fi
			sed -i "/^- /d" $cpick_commit
			cut -d " " -f 2 $cpick_commit > $cpick_tmp
			mv $cpick_tmp $cpick_commit
		fi
	fi
# 1. new pick, but commit is null
# 2. old pick, but commit left is null
# 3. error input
	if [ ! -e $cpick_commit ];then
		rm $cpick_is_error
		echo "no commit file"
		echo "usage: cpick [branchA branchB]"
		return
	else
		if [ ! -s $cpick_commit ];then
			echo "commits file is empty, nothing to pick, cherry-pick complete"
			rm cpick*.tmp
			return
		fi
	fi
# cherry-pick commits
	cat $cpick_commit | while read line
	do
		sed -i "/$line/d" $cpick_commit
		git cherry-pick $line
		if [ $? -ne 0 ];then
			echo 1 > $cpick_is_error
			break
		fi
	done

	if [ `cat $cpick_is_error` -eq 1 ];then
		echo -e "\033[31mcherry-pick error, please fix it\033[0m"
		rm $cpick_is_error
		return
	else
		echo -e "\033[32mcherry-pick complete\033[0m"
		rm cpick*.tmp
		return
	fi
}
complete -F __ding_cmd_HUB 2ding
complete -F __ding_cmd_HUB ding
function __ding_cmd
{
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local options="`cut -d " " -f 1 ~/.ding`"
    COMPREPLY=( $(compgen -W "${options}" -- ${cur}) )
}
function __ding_cmd_HUB
{
	case $COMP_CWORD in
	0)  ;;
	1)  if [ ${COMP_WORDS[0]} == 2ding ];then
		    eval __ding_cmd
		fi
		;;
	2)  if [ ${COMP_WORDS[0]} == ding -a ${COMP_WORDS[1]} == '-d' ];then
	        eval __ding_cmd
	    fi
	    ;;
	esac
}
function ding
{
	local DING_FILE_PATH="$HOME/.ding"
	if [ $# -eq 0 ]
	then
		if [ -e $DING_FILE_PATH ]
		then
		    cat $DING_FILE_PATH | sort | while read line
		    do
		        echo -e "\033[31m`echo -n $line | cut -d ' ' -f 1`	\033[36m`echo -n $line | cut -d ' ' -f 2-`\033[0m"
		    done
		else
		    echo "No ding file"
		fi
	fi

	OPTIND=0
	while getopts :Dd:hvz opt
	do
		case $opt in
		d)	if [ -e $DING_FILE_PATH ]
       	    then
       	        grep "^$OPTARG " $DING_FILE_PATH > /dev/null
				ret=$?
				if [ $ret -eq 0 ]
				then
					cp $DING_FILE_PATH "$DING_FILE_PATH.bak"
				fi
				sed -i "/^$OPTARG /d" $DING_FILE_PATH
				if [ $ret -eq 0 ]
				then
					echo -e "\033[31mDel ding \033[36m$OPTARG\033[0m"
				else
					echo -e "\033[31mNo such ding \033[36m$OPTARG\033[0m"
				fi
       	    else
       	        echo "No ding file"
       	    fi
			;;
		D)	if [ -e $DING_FILE_PATH ]
			then
				cp $DING_FILE_PATH "$DING_FILE_PATH.bak"
				rm $DING_FILE_PATH
				echo "Del all dings"
			else
				echo "No ding file"
			fi
			;;
		h)	echo "Usage: ding [-dDzvh] [DING_NAME]"
			echo "ding DING_NAME : store current path to \"DING_NAME\""
			echo "ding : list all stored dings"
			echo "ding -d DING_NAME : delete existing ding named \"DING_NAME\", can user regexp"
			echo "ding -D : delete all dings stored"
			echo "ding -z : roll back the previous revision"
			echo "ding -v : show version"
			echo "ding -h : show usage"
			;;
		v)	echo "Version 3.0"
			echo "Designed by liuqi@microtrust.com.cn"
			;;
		z)	if [ -e "$DING_FILE_PATH.bak" ]
			then
				mv "$DING_FILE_PATH.bak" $DING_FILE_PATH
				echo "Back in time"
			else
				echo "No ding back file"
			fi
			;;
		?)	echo "Invalid option, use -h to see usage"
			;;
		esac
	done

	shift $((OPTIND - 1))
	
	if [ $# -eq 1 ]
    then
        if [ -e $DING_FILE_PATH ]
        then
			cp $DING_FILE_PATH "$DING_FILE_PATH.bak"
            sed -i "/^$1 /d" $DING_FILE_PATH
        fi

        DING_NAME="$1 $PWD"
        echo -e "$DING_NAME" >> $DING_FILE_PATH
        echo -e "\033[31mDing \033[36m$PWD \033[31mto \033[36m$1\033[0m"
	fi
}
function 2ding
{
	local DING_FILE_PATH="$HOME/.ding"
    OPTIND=0
	while getopts :vh opt
	do
		case $opt in
			h)  echo "Usage: 2ding [-vh] [DING_NAME]"
				echo "2ding DING_NAME : jump to the path stored in \"DING_NAME\""
				echo "2ding -v : show version"
				echo "2ding -h : show usage"
				;;
			v)	echo "Version 3.0"
				echo "Designed by liuqi@microtrust.com.cn"
				;;
			?)	echo "Invalid option, use -h to see usage"
				;;
		esac
	done
	shift $((OPTIND - 1))

	path=""
    if [ $# -eq 1 ]
    then
        if [ -e $DING_FILE_PATH ]
        then
            path=`sed -n "/^$1 /p" $DING_FILE_PATH`
            if [ "$path" != "" ]
            then
                cd "`echo -n "$path" | cut -d ' ' -f 2-`"
            else
                echo "Not find path"
            fi
        else
            echo "No ding file"
        fi
    fi
}

function ccolor
{
    shopt -u expand_aliases
    eval "$*" 2>&1 | awk '{
        IGNORECASE=1;
        if($0~/ error[s]*[ :]/){
            print "\033[31m"$0"\033[0m";
        }
        else if($0~/ warning[s]*[ :]/){
            print "\033[33m"$0"\033[0m";
        }
        else
            print;
    }'
    shopt -s expand_aliases
}
alias gcc="ccolor gcc"
alias g++="ccolor g++"
alias make="ccolor make"
alias mm="ccolor mm"
alias mmm="ccolor mmm"
alias zhmakepkg="ccolor zhmakepkg"
alias soter_make="ccolor soter_make"
alias sboot_make="ccolor sboot_make"
