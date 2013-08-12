# ######################################################
# Last review            Mon 18 Mar 2013 01:52:47 AM CST
# ######################################################
#  vim: set ts=8 sw=4 tw=0 ft=sh:

#core startup programs, use ~/.i3/startup when possible

#background
feh --bg-scale ~/.data/images/wallpapers/sun.png #fallback
#xsetroot -solid "#000000"

#numlockx on &                                 # numlock on
#setxkbmap -option terminate:ctrl_alt_bksp &   # C-A-BS to kill X

exec /usr/bin/i3                               # start i3
#exec /usr/bin/i3 >> ~/.i3/logfile             # start i3 with standard messages
#exec /usr/bin/i3 -d all >> ~/.i3/logfile      # start i3 debug
#exec /usr/bin/i3 -V -d all >> ~/.i3/logfile   # start i3 debug, super verbose mode
