#-------------------------------------------------------------------------------
#           Last review            Mon 02 May 2011 03:46:59 AM CDT
#-------------------------------------------------------------------------------

if [ -f $HOME/.bashrc ]; then
   source $HOME/.bashrc
fi

#/etc/X11/Xsession.d/90gpg-agent
if test -f /usr/bin/gpg-agent && grep -qs '^[[:space:]]*use-agent'\
    "$HOME/.gnupg/gpg.conf" "$HOME/.gnupg/options"; then
    PID_FILE="$HOME/.gnupg/gpg-agent-info-$(hostname)"
    # Invoke GnuPG-Agent the first time we login.
    # If it exists, use this:
    if test -f $PID_FILE && kill -0 $(cut -d: -f 2 $PID_FILE) 2>/dev/null; then
        GPG_AGENT_INFO=$(cat $PID_FILE | cut -c 16-)
        GPG_TTY=$(tty) #for mutt & other console apps
        export GPG_TTY
        export GPG_AGENT_INFO
    else
        # Otherwise, it either hasn't been started, or was killed:
        eval $(gpg-agent --enable-ssh-support --daemon --no-grab --write-env-file $PID_FILE)
        GPG_TTY=$(tty) #for mutt & other console apps
        export GPG_TTY
        export GPG_AGENT_INFO
    fi
fi
