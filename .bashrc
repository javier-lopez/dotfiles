#-------------------------------------------------------------------------------
#           Last review            Thu 05 Apr 2012 06:25:00 PM CDT
#-------------------------------------------------------------------------------

#===============================================================================
#================================= General =====================================
#===============================================================================

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# http://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
if [ $BASH_VERSINFO -ge 4 ]; then
    shopt -s autocd cdspell dirspell
fi

shopt -s checkhash checkwinsize cmdhist expand_aliases histreedit mailwarn
shopt -s hostcomplete histappend

set match-hidden-files off
set bind-tty-special-chars on
set completion-ignore-case on

set -o vi #this is sparta!

# Do not show ^C when pressing Ctrl+C
stty -ctlecho

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# PS1
# Grabbed mostly from Yu-Jie Lin
[[ $TERM == 'linux' ]] && STR_MAX_LENGTH=2 || STR_MAX_LENGTH=4
NORMAL_COLOR='\[\e[00m\]'
DATE_COLOR='\[\e[01;35m\]'
HOST_COLOR='\e[0;32m'
USER_COLOR='\e[0;34m'
DIR_COLOR='\[\e[1;32m\]'
DIR_HOME_COLOR='\[\e[1;35m\]'
DIR_SEP_COLOR='\[\e[1;31m\]'
ABBR_DIR_COLOR='\[\e[1;37m\]'

NEW_PWD='$(
p=${PWD/$HOME/}
[[ "$p" != "$PWD" ]] && echo -n "'"$DIR_HOME_COLOR"'~"
if [[ "$p" != "" ]]; then
until [[ "$p" == "$d" ]]; do
    p=${p#*/}
    d=${p%%/*}
    dirnames[${#dirnames[@]}]="$d"
done
fi
for (( i=0; i<${#dirnames[@]}; i++ )); do
    if (( i == 0 )) || (( i == ${#dirnames[@]} - 1 )) || (( ${#dirnames[$i]} <= '"$STR_MAX_LENGTH"' )); then
        echo -n "'"$DIR_SEP_COLOR"'/'"$DIR_COLOR"'${dirnames[$i]}"
    else
        echo -n "'"$DIR_SEP_COLOR"'/'"$ABBR_DIR_COLOR"'${dirnames[$i]:0:'"$STR_MAX_LENGTH"'}"
    fi
done
)'

STATUS='$(
ret=$?
if [ "${ret}" = 0 ]; then
    echo -e "\e[01;32m0"
else echo -e "\e[01;31m$ret";
fi
)'


# the first $DIR_COLOR can be removed
PS1="$NORMAL_COLOR╔═${debian_chroot:+($debian_chroot)}[$DATE_COLOR\D{%R %a(%d).%b}$NORMAL_COLOR] $USER_COLOR\u$NORMAL_COLOR@$HOST_COLOR\h$NORMAL_COLOR [$STATUS$NORMAL_COLOR:$DIR_COLOR$NEW_PWD$NORMAL_COLOR]\n╚═[\$] "

unset STR_MAX_LENGTH DIR_COLOR DIR_HOME_COLOR DIR_SEP_COLOR ABBR_DIR_COLOR USER_COLOR NEW_PWD PS1_ERROR

#http://aymanh.com/how-debug-bash-scripts
export PS4='>>(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

if [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
fi

# Change the window title of X terminals
# originally from /etc/bash/bashrc on Gentoo
case ${TERM} in
	xterm*|rxvt*|Eterm|aterm|kterm|gnome*|interix)
		PROMPT_COMMAND='echo -ne "\033]0;${PWD/$HOME/~}\007"'
		;;
	screen)
		PROMPT_COMMAND='echo -ne "\033_${PWD/$HOME/~}\033\\"'
		;;
esac

PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ; }"\
'echo $USER \ \ \ \ \ "$(history 1)" >> ~/.bash_eternal_history'

#===============================================================================
#=============================== Custom vars  ==================================
#===============================================================================

export LESS_TERMCAP_mb=$'\e[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\e[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\e[0m'           # end mode
export LESS_TERMCAP_se=$'\e[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\e[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\e[0m'           # end underline
export LESS_TERMCAP_us=$'\e[04;38;5;146m' # begin underline
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
export HISTCONTROL=ignoreboth

# grep
export GREP_COLOR='1;35' #purple
export GREP_OPTIONS=--color=auto

# android
export PATH=$PATH:$HOME/code/android/android-sdk-linux_x86/tools/                                              
export PATH=$PATH:$HOME/code/android/android-sdk-linux_x86/platform-tools/

# gpg
export GPGKEY=BC9C8902
export GPG_TTY=$(tty)

# random vars
export EDITOR="vim" #is there any other choice?
export WCDHOME="$HOME/.wcd" #wcd magic
#export TERM=rxvt
export BROWSER="firefox"
export CSCOPE_EDITOR=vim
export PKG_CONFIG_PATH=/opt/e17/lib/pkgconfig/
export DISPLAY=:0.0

#export BLACK=$'\e[0;30m'
#export BLUE=$'\e[0;34m'
#export BROWN=$'\e[0;33m'
#export CYAN=$'\e[0;36m'
#export DARK_GREY=$'\e[1;30m'
#export DEFAULT=$'\e[0m'
#export GREEN=$'\e[0;32m'
#export LIGHT_BLUE=$'\e[1;34m'
#export LIGHT_CYAN=$'\e[1;36m'
#export LIGHT_GREEN=$'\e[1;32m'
#export LIGHT_GREY=$'\e[0;37m'
#export LIGHT_PURPLE=$'\e[1;35m'
#export LIGHT_RED=$'\e[1;31m'
#export PURPLE=$'\e[1;35m'
#export RED=$'\e[0;31m'
#export WHITE=$'\e[1;37m'
#export YELLOW=$'\e[0;33m'

#ls colors
eval $(dircolors -b $HOME/.dir_colors)

#show the todo list every 10 terminal invocations, aprox
rnumber=$((RANDOM%10))
if [ $rnumber == 5 ]; then
    todo ls +5
    todo ls +in_progress
    todo ls @debug| head -5 -v
fi

#===============================================================================
#=============================== Custom alias ==================================
#===============================================================================

source ~/.alias.common

OS=$(uname)
case $OS in
    Linux)
        source ~/.alias.linux
        ;;
    OpenBSD)
        source ~/.alias.openbsd
        ;;
    *)
esac
