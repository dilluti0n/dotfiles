#!/bin/bash

eval $(dbus-launch --sh-syntax --exit-with-session)

[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

export XMODIFIRES="@im=fcitx"
export QT_IM_MODULE="fcitx"
export GTK_IM_MODULE="fcitx"
export XDG_CONFIG_HOME="$HOME/.config"

xset m 0 0
xset b off
setxkbmap -option 'ctrl:nocaps'
# setxkbmap -option 'ctrl:swapcaps'

#xfce4-power-manager &
#xfce4-panel --disable-wm-check &
blueman-applet &
# iwgtk -i &
nm-applet &
libinput-gestures-setup start
redshift &
fcitx5 &
slstatus &
$HOME/.fehbg &
picom --daemon
# discord --start-minimized &

exec dwm
