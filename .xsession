# ######################################################
# Last review            Tue 17 May 2011 04:17:34 PM CDT
# ######################################################
#  vim: set ts=8 sw=4 tw=0 ft=sh: 

#background
#eval `cat $HOME/.fehbg` &                     # set background
#xsetroot -solid "#333333"                     # or use a solid color
feh --bg-scale /home/chilicuil/tmp_img/circles.jpg
#feh --bg-scale $HOME/data/images/wallpapers/Aurora_Borealis.jpg

xsetroot -cursor_name left_ptr
#numlockx on &                                 # numlock on
#setxkbmap -option terminate:ctrl_alt_bksp &   # C-A-BS to kill X
#xrdb $HOME/.Xdefaults &                       # force to load Xdefaults

#exec /usr/bin/xmonad                          # start xmonad
#exec /usr/bin/enlightenment_start             # start e17
#exec /usr/bin/i3 -V all >> ~/.i3/logfile      # start i3 debug
exec /usr/bin/i3 >> ~/.i3/logfile              # start i3

#case $1 in
#i3)
    #exec /usr/bin/i3
   #;;

#e17)
    #exec /usr/bin/enlightenment_start
   #;;

##openbox)
        ##exec openbox-session
        ##;;

##icewm)
   ##exec enlightenment_start
   ##;;
#esac
