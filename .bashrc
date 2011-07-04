#-------------------------------------------------------------------------------
#           Last review            Sun 16 May 2010 11:23:56 PM CDT
#-------------------------------------------------------------------------------

#===============================================================================
#================================= General =====================================
#===============================================================================

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# http://launchpadlibrarian.net/59511828/cgroup_patch
# /etc/rc.local
#   mkdir -p /dev/cgroup/cpu
#   mount -t cgroup cgroup /dev/cgroup/cpu -o cpu
#   mkdir -m 0777 /dev/cgroup/cpu/user
#   echo "/usr/local/sbin/cgroup_clean" > /dev/cgroup/cpu/release_agent
#   exit 0
if [ "$PS1" ] ; then
    mkdir -p -m 0700 /dev/cgroup/cpu/user/$$ > /dev/null 2>&1
    echo $$ > /dev/cgroup/cpu/user/$$/tasks
    echo "1" > /dev/cgroup/cpu/user/$$/notify_on_release
fi

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

force_color=yes

if [ "$force_color" = yes ]; then
    PS1='╔═${debian_chroot:+($debian_chroot)}[\[\033[01;35m\]\D{%R %a(%d).%b}\[\033[00m\]] \[\033[00;32m\]\u@\h\[\033[00m\] [`if [ \$? = 0 ]; then echo -e "\e[01;32m0"; else echo -e "\e[01;31m-1"; fi`\[\033[1;37m\]:`readlink /proc/self/fd/0`:\[\033[01;34m\]\w\[\033[00m\]]\n╚═[\$] '
else
    PS1='╔═${debian_chroot:+($debian_chroot)}[\D{%R %a(%d).%b}] \u@\h [`if [ \$? = 0 ]; then echo -e "0"; else echo -e "-1"; fi`:`readlink /proc/self/fd/0`:\w]\n╚═[\$] '
fi

if [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
fi

PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ; }"\
'echo $USER \ \ \ \ \ "$(history 1)" >> ~/.bash_eternal_history'

#===============================================================================
#=============================== Custom vars  ==================================
#===============================================================================

export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
export HISTCONTROL=ignoreboth

# grep
export GREP_COLOR='1;35' #purple
export GREP_OPTIONS=--color=auto

#export BLACK=$'\E[0;30m'
#export BLUE=$'\E[0;34m'
#export BROWN=$'\E[0;33m'
#export CYAN=$'\E[0;36m'
#export DARK_GREY=$'\E[1;30m'
#export DEFAULT=$'\E[0m'
#export GREEN=$'\E[0;32m'
#export LIGHT_BLUE=$'\E[1;34m'
#export LIGHT_CYAN=$'\E[1;36m'
#export LIGHT_GREEN=$'\E[1;32m'
#export LIGHT_GREY=$'\E[0;37m'
#export LIGHT_PURPLE=$'\E[1;35m'
#export LIGHT_RED=$'\E[1;31m'
#export PURPLE=$'\E[1;35m'
#export RED=$'\E[0;31m'
#export WHITE=$'\E[1;37m'
#export YELLOW=$'\E[0;33m'

#ls colors
eval $(dircolors -b $HOME/.dir_colors)

#===============================================================================
#=============================== Custom alias ==================================
#===============================================================================

OS=$(uname)

case $OS in
    Linux)
        source ~/.alias.linux
        ;;
    OpenBSD)
        source ~/.alias.openbsd
        ;;
    #*)
        #source ~/.alias.common
esac
