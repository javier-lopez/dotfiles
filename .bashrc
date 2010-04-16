#-------------------------------------------------------------------------------
#           Last review            Fri 16 Apr 2010 04:45:33 AM CDT
#-------------------------------------------------------------------------------

#===============================================================================
#================================= General =====================================
#===============================================================================

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

force_color_prompt=yes

if [ "$force_color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;35m\]$(date +\%R) \[\033[00;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}$(date +\%R) \u@\h:\w\$ '
fi

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi



#===============================================================================
#============================ Custom functions =================================
#===============================================================================

#===Custom Alias===
alias .bashrc='vim ~/.bashrc'
alias .bashrc_='vim ~/.bashrc_'
alias c='cd'
alias cc='LANGUAGE=en cc'
alias ..='cd ..'
alias cd..='cd ..'
alias dev='vim -c DevMode'
alias dir='ls -d */'
alias dmesg.tail='dmesg|tail -f'
alias framework='cd ~/code/framework-trunk/'
alias gcc='LANGUAGE=en gcc'
alias install='sudo apt-get install'
alias JDownloader='java -jar /home/chilicuil/code/JDownloader/JDownloader.jar'
alias jdownloader='JDownloader'
alias kcore='sudo cat /proc/kcore | strings | less'
alias la='ls -A'
alias la='ls -A'
alias Learn.autocp='cd ~/code/learn/autocp/bash_completion.d/'
alias Learn.c='cd ~/code/learn/c/'
alias Learn.c++='cd ~/code/learn/c++/'
alias Learn='cd ~/code/learn/'
alias Learn.html='cd ~/code/learn/html/'
alias Learn.java='cd ~/code/learn/java/'
alias Learn.perl='cd ~/code/learn/perl/'
alias Learn.php='cd ~/code/learn/php/'
alias Learn.python='cd ~/code/learn/python/'
alias Learn.ruby='cd ~/code/learn/ruby/'
alias Learn.sh='cd ~/code/learn/sh/'
alias lh='ls -lah'
alias ll='ls -l'
alias l='ls -CF'
alias ls='ls --color=auto'
alias lss='ls'
alias make='LANGUAGE=en make'
alias match='join'
alias mkdir='mkdir -vp'
alias mutt='LANGUAGE=en mutt'
alias mv='mv -v'
alias cp='cp -v'
alias plugin='cd ~/.vim/plugin/'
alias purge='sudo apt-get purge'
alias remove='sudo apt-get remove'
alias s='ls -CF'
alias so='source ~/.bashrc'
alias st='setup'
alias terminal='gnome-terminal'
alias todo='todo -d ~/.todo/todo.cfg'
alias tree="tree -CFa -I 'CVS|*.*.package|.svn|.git' --dirsfirst"
alias .et='vim .bash_eternal_history'
alias t='todo'
alias update='sudo apt-get update'
alias upgrade='sudo apt-get upgrade'
alias vd='vim -c DevMode'
alias vimdev='vim -c DevMode'
alias vrc='vim ~/.vimrc'
alias v='vim'
alias wifi='iwlist eth1 s'
alias zz='exit'
#================================================



#===Custom Vars===
export DEBEMAIL="chilicuil@users.sourceforge.net"
export DEBFULLNAME="chilicuil"
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/opt/e17/bin:/opt/e17/bin:/opt/e17-ecomorph/bin:/usr/local/bin/bin/:/opt/bochs/bin/

export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
export HISTCONTROL=ignoreboth
#export HISTTIMEFORMAT="%s "

export BLACK=$'\E[0;30m'
export BLUE=$'\E[0;34m'
export BROWN=$'\E[0;33m'
export CYAN=$'\E[0;36m'
export DARK_GREY=$'\E[1;30m'
export DEFAULT=$'\E[0m'
export GREEN=$'\E[0;32m'
export LIGHT_BLUE=$'\E[1;34m'
export LIGHT_CYAN=$'\E[1;36m'
export LIGHT_GREEN=$'\E[1;32m'
export LIGHT_GREY=$'\E[0;37m'
export LIGHT_PURPLE=$'\E[1;35m'
export LIGHT_RED=$'\E[1;31m'
export PURPLE=$'\E[1;35m'
export RED=$'\E[0;31m'
export WHITE=$'\E[1;37m'
export YELLOW=$'\E[0;33m'

#====Misc settings=====
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ; }"\
'echo $USER \ \ \ \ \ "$(history 1)" >> ~/.bash_eternal_history'
set match-hidden-files off
#"\e[A": history-search-backward
#"\e[B": history-search-forward
#mint-fortune
