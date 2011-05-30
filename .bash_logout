# Last review            Mon 17 May 2010 02:11:03 AM CDT

# ~/.bash_logout: executed by bash(1) when login shell exits.
# when leaving the console, kill gpg-agent & clear the screen
kill $SSH_AGENT_PID

if [ "$SHLVL" = 1 ]; then
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi
