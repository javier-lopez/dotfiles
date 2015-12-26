#-------------------------------------------------------------------------------
#           Last review            Wed 23 Apr 2014 04:16:19 PM CDT
#-------------------------------------------------------------------------------

#===============================================================================
#================================= General =====================================
#===============================================================================

# do nothing if not running interactively
[ -z "${PS1}" ] && return

set -o vi #this is sparta!
stty -ctlecho #don't show ^C when pressing Ctrl+C

# http://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
[ "${BASH_VERSINFO}" -ge "4" ] && shopt -s autocd cdspell dirspell
shopt -s checkhash checkwinsize cmdhist expand_aliases histreedit mailwarn
shopt -s hostcomplete histappend histverify

bind "set match-hidden-files off"     #don't match hidden files
bind "set bind-tty-special-chars on"  #punctuations are not word delimiters
bind "set show-all-if-ambiguous on"   #enable single tab completion
bind "set completion-ignore-case on"

#trap '. /etc/bash_completion ; trap USR2' USR2
#{ sleep 0.01 ; builtin kill -USR2 $$ ; } & disown
[ -z "${BASH_COMPLETION_COMPAT_DIR}" ] && [ -f /etc/bash_completion ] && . /etc/bash_completion

# make less more friendly for non-text input files, see lesspipe(1)
if command -v "lesspipe" >/dev/null 2>&1; then
    eval "$(SHELL=/bin/sh lesspipe)"
fi

#/etc/terminfo/*
#export TERM="xterm-color"
#export TERM="xterm-256color"

# Change the X terminal window title
case "${TERM}" in
    xterm*|rxvt*|Eterm|aterm|kterm|gnome*|interix)
        PROMPT_COMMAND='printf "%b" "\033]0;${PWD/$HOME/~}\007"' ;;
    screen)
        PROMPT_COMMAND='printf "%b" "\033_${PWD/$HOME/~}\033\\"' ;;
esac

#===============================================================================
#=============================== Environment  ==================================
#===============================================================================

# path
export PATH="$HOME/code/tmux/bin:/bin:/sbin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/usr/bin/X11:/usr/games"
#export PATH="/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/bin/X11:/usr/games"

# gpg
export GPGKEY="C92C604E"
export GPG_TTY="$(tty)"

# random vars
export EDITOR="editor"
export CSCOPE_EDITOR="editor"
export WCDHOME="${HOME}/.wcd"
export BROWSER="x-www-browser"
#export LC_ALL=C

#fix java ugliness
export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"

# ruby dev
#[ -f "${HOME}/.rvm/bin" ] && export PATH="${PATH}:${HOME}/.rvm/bin"
#[ -f "$HOME/.rvm/scripts/rvm" ] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

#ubuntu dev
export DEBEMAIL="chilicuil@ubuntu.com"
export DEBFULLNAME="Javier P.L."
export QUILT_PATCHES="debian/patches"
export QUILT_PUSH_ARGS="--color=auto"
export QUILT_DIFF_ARGS="--no-timestamps --no-index -p ab --color=auto"
export QUILT_REFRESH_ARGS="--no-timestamps --no-index -p ab"
export QUILT_DIFF_OPTS='-p'

if [ -f "$(command -v "ccache")" ]; then
    export PATH="${PATH}:/usr/lib/ccache"
    export CCACHE_DIR="${HOME}/.ccache"
    export CCACHE_SIZE="2G"
    #export CCACHE_PREFIX="distcc"
fi

#===============================================================================
#================================= Plugins =====================================
#===============================================================================

if [ -f ~/.shundle/bundle/shundle/shundle ]; then
    .  ~/.shundle/bundle/shundle/shundle
    Bundle='chilicuil/shundle'
        #SHUNDLE_ENV_VERBOSE="0"
        #SHUNDLE_ENV_DEBUG="0"
        SHUNDLE_ENV_COLOR="1"
    #Bundle='chilicuil/shundle-plugins/todo-rememberator'
        #REMEMBERATOR_EVERY="5"
    Bundle="gh:chilicuil/shundle-plugins/eternalize"
        ETERNALIZE_PATH="${HOME}/.eternalize-data"
    Bundle="github:chilicuil/shundle-plugins/colorize"
        COLORIZE_THEME="default-dark"
        COLORIZE_PS="yujie"
        COLORIZE_UTILS="sky"
    Bundle="chilicuil/shundle-plugins/aliazator.git"
        #ALIAZATOR_PLUGINS="none"
        #ALIAZATOR_PLUGINS="minimal"
        ALIAZATOR_PLUGINS="installed"
        #ALIAZATOR_PLUGINS="all"
        #ALIAZATOR_PLUGINS="custom:minimal,git,apt-get,vagrant,vim"
        #ALIAZATOR_CLOUD="url"
    Bundle="gh:chilicuil/shundle-plugins/autocd"
        #AUTOCD_FILE="/tmp/autocd.59YlpZ50"
else
    alias shundle-install='git clone --depth=1 https://github.com/chilicuil/shundle ~/.shundle/bundle/shundle'
fi
