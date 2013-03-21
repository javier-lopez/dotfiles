# ######################################################
# Last review            Mon 18 Mar 2013 01:52:47 AM CST
# ######################################################
#  vim: set ts=8 sw=4 tw=0 ft=sh: 

#background
xsetroot -solid "#000000"                     # or use a solid color
#eval `cat $HOME/.fehbg` &                     # set background
#feh --bg-scale /home/chilicuil/data/images/wallpapers/sun.png
#mplayer -loop 0 -rootwin -ao null -noconsolecontrols /home/chilicuil/data/video/earth.mp4 &
#feh --bg-scale /home/chilicuil/data/images/wallpapers/wallcolor.jpg

#redshift -l 19.41:-99.04 -t 6500:4500 -g 0.8 -v &
#redshift -l 19.41:-99.04 -t 6500:3600 -g 0.8 -v &

#numlockx on &                                 # numlock on
#setxkbmap -option terminate:ctrl_alt_bksp &   # C-A-BS to kill X

#exec /usr/bin/xmonad                          # start xmonad
#exec /usr/bin/enlightenment_start             # start e17

#exec /usr/bin/i3 -d all >> ~/.i3/logfile      # start i3 debug
#exec /usr/bin/i3 -V -d all >> ~/.i3/logfile   # start i3 debug, super verbose mode
#exec /usr/bin/i3 >> ~/.i3/logfile             # start i3
exec /usr/bin/i3                               # start i3
