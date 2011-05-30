# ######################################################
# Last review            Tue 17 May 2011 04:17:34 PM CDT
# ######################################################
#  vim: set ts=8 sw=4 tw=0 ft=sh: 

#eval `cat $HOME/.fehbg` &                     # set background
#feh --bg-scale ~/some_cool_wp.png
#xsetroot -solid "#333333"                     # or use a solid color
#xsetroot -cursor_name left_ptr                # req'd for xmonad's cursor
#xset fp+ /usr/share/fonts/local &             # add local fonts

#xset s 1200 1200 &                            # set monitor to sleep 20 mins

#numlockx on &                                 # numlock on

#setxkbmap -option terminate:ctrl_alt_bksp &   # C-A-BS to kill X

#urxvtd -q -f -o &                             # start urxvt daemon

#xcompmgr -fF &                                # allow transparency

#xrdb $HOME/.Xdefaults &                       # force to load Xdefaults

#setterm -blank 0 -powersave off -powerdown 0
#xset s off
autocutsel &                                   #sync X/Gnome clipboards
autocutsel -s PRIMARY &

#exec /usr/bin/xmonad                          # start xmonad
#exec /opt/e17/bin/enlightenment_start         # start e17
exec /usr/bin/i3                               # start i3

#case $1 in
#i3)
    ##exec /usr/bin/i3
    #exec x-terminal-emulator
   #;;

#e17)
    #exec /opt/e17/bin/enlightenment_start
   #;;

##openbox)
        ##exec openbox-session
        ##;;

##icewm)
   ##exec enlightenment_start
   ##;;
#esac
