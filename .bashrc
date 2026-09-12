#===============================================================================
#================================= General =====================================
#===============================================================================

#do nothing if not running interactively
[ -z "${PS1}" ] && return

set -o vi #this is sparta!
stty -ctlecho #don't show ^C when pressing Ctrl+C

#http://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
[ "${BASH_VERSINFO}" -ge "4" ] && shopt -s autocd cdspell dirspell
shopt -s checkhash checkwinsize cmdhist expand_aliases histreedit mailwarn
shopt -s hostcomplete histappend histverify

bind "set match-hidden-files off"     #don't match hidden files
bind "set bind-tty-special-chars on"  #punctuations are not word delimiters
bind "set show-all-if-ambiguous on"   #enable single tab completion
bind "set completion-ignore-case on"

[ -z "${BASH_COMPLETION_COMPAT_DIR}" ] && [ -f /etc/bash_completion ] && . /etc/bash_completion

#make less more friendly for non-text input files, see lesspipe(1)
#if command -v "lesspipe" >/dev/null 2>&1; then
    #eval "$(SHELL=/bin/sh lesspipe)"
#fi

#/etc/terminfo/*
#export TERM="xterm-color"
#export TERM="xterm-256color"

#change X terminal window title
case "${TERM}" in
    xterm*|rxvt*|Eterm|aterm|kterm|gnome*|interix)
        PROMPT_COMMAND='printf "%b" "\033]0;${PWD/$HOME/~}\007"' ;;
    screen)
        PROMPT_COMMAND='printf "%b" "\033_${PWD/$HOME/~}\033\\"' ;;
esac

#===============================================================================
#=============================== Environment  ==================================
#===============================================================================

[ -d "$HOME/bin" ]        && export PATH="${HOME}/bin:${PATH}"
[ -d "$HOME/.local/bin" ] && export PATH="${HOME}/.local/bin:${PATH}"
[ -d "$HOME/.bin" ]       && export PATH="${HOME}/.bin:${PATH}"

#gpg
export GPGKEY="6ACFB9D8"
export GPG_TTY="$(tty)"

#random vars
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

# node
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ]          && . "$NVM_DIR/nvm.sh"           # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#ubuntu dev
export DEBEMAIL="javier-lopez@ubuntu.com"
export DEBFULLNAME="Javier López"
export QUILT_PATCHES="debian/patches"
export QUILT_PUSH_ARGS="--color=auto"
export QUILT_DIFF_ARGS="--no-timestamps --no-index -p ab --color=auto"
export QUILT_REFRESH_ARGS="--no-timestamps --no-index -p ab"
export QUILT_DIFF_OPTS='-p'

if [ -f "$(command -v "ccache")" ]; then
    export PATH="${PATH}:/usr/lib/ccache"
    export CCACHE_DIR="${HOME}/.ccache"
    export CCACHE_SIZE="2G"
fi

# claude, feeds the official GitHub MCP server (plugin:github:github)
export GITHUB_PERSONAL_ACCESS_TOKEN="$(gh auth token)"

#===============================================================================
#================================= Plugins =====================================
#===============================================================================

if [ -f ~/.shundle/bundle/shundle/shundle ]; then
    .  ~/.shundle/bundle/shundle/shundle
    Bundle='javier-lopez/shundle'
        #SHUNDLE_ENV_VERBOSE="0"
        #SHUNDLE_ENV_DEBUG="0"
        SHUNDLE_ENV_COLOR="1"
    #Bundle='javier-lopez/shundle-plugins/todo-rememberator'
        #REMEMBERATOR_EVERY="5"
    Bundle="gh:javier-lopez/shundle-plugins/eternalize"
        ETERNALIZE_PATH="${HOME}/.eternalize-data"
        ETERNALIZE_IGNORE="cd,cd *,ls,ls *,pwd,exit,clear,history,history *"
        ETERNALIZE_BIND='"\C-r"' #control-r gets overrided for history search
        PostInstall='wget -qO- \
            https://github.com/junegunn/fzf/releases/download/v0.74.4/fzf-0.74.4-linux_amd64.tar.gz | \
            tar xz -C ~/.local/bin fzf && chmod +x ~/.local/bin/fzf'
    Bundle="github:javier-lopez/shundle-plugins/colorize"
        COLORIZE_THEME="default-dark"
        COLORIZE_PS="yujie"
        COLORIZE_UTILS="sky"
        COLORIZE_GITPROMPT="branch" #dirty marks changes, at one git per prompt
    Bundle="javier-lopez/shundle-plugins/aliazator.git"
        #ALIAZATOR_PLUGINS="none"
        #ALIAZATOR_PLUGINS="minimal"
        ALIAZATOR_PLUGINS="installed"
        ALIAZATOR_OVERRIDE="size install gs"
        #ALIAZATOR_PLUGINS="all"
        #ALIAZATOR_PLUGINS="custom:minimal,git,apt-get,vagrant,vim"
        #ALIAZATOR_CLOUD="url"
    Bundle="gh:javier-lopez/shundle-plugins/autocd"
        #AUTOCD_FILE="/tmp/autocd.59YlpZ50"
else
    alias shundle-install='git clone --depth=1 \
    https://github.com/javier-lopez/shundle ~/.shundle/bundle/shundle && \
    . ~/.bashrc && ~/.shundle/bundle/shundle/bin/shundle install   && \
    bash'
fi

[ -f ~/.credentials ] && . ~/.credentials
