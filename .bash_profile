#-------------------------------------------------------------------------------
#           Last review            Sat 17 May 2014 10:26:15 AM CDT
#-------------------------------------------------------------------------------

[ -f "${HOME}/.bashrc" ] && source "${HOME}/.bashrc"

#/etc/X11/Xsession.d/90gpg-agent
if command -v "gpg-agent" >/dev/null 2>&1 &&
   grep '^[[:space:]]*use-agent'"${HOME}/.gnupg/gpg.conf" \
   "${HOME}/.gnupg/options" >/dev/null 2>&1; then
    PID_FILE="${HOME}/.gnupg/gpg-agent-info-$(hostname)"
    # Invoke GnuPG-Agent the first time we login.
    # If it exists, use this:
    if [ -f ${PID_FILE} ] && kill -0 "$(cut -d: -f2 "${PID_FILE}")" 2>/dev/null; then
        GPG_AGENT_INFO="$(cat ${PID_FILE} | cut -c 16-)"
        GPG_TTY="$(tty)" #for mutt & other console apps
        export GPG_TTY
        export GPG_AGENT_INFO
    else
        # Otherwise, it either hasn't been started, or was killed:
        eval $(gpg-agent --enable-ssh-support --daemon --no-grab --write-env-file "${PID_FILE}")
        GPG_TTY="$(tty)" #for mutt & other console apps
        export GPG_TTY
        export GPG_AGENT_INFO
    fi
fi

_byobu_sourced=1 . /usr/bin/byobu-launch
