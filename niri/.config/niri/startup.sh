#!/bin/sh
# ~/.config/niri/startup.sh

dbus-update-activation-environment --systemd \
    WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE
gpg-connect-agent updatestartuptty /bye

# portal
/usr/libexec/xdg-desktop-portal-gtk &
/usr/libexec/xdg-desktop-portal -r &

# session
gentoo-pipewire-launcher &
fcitx5 -d
mako &
swayosd-server &
poweralertd &
mute-led &
usbnotifyd &

# ui
swaybg -m fit -i "$HOME/Images/wallpapers/rei.jpg" -c '#000000' &
waybar &
wlsunset &
{ eww daemon && eww-subscribe-monitor; } &

swayidle -w \
    timeout 300 'swaylock -f' \
    timeout 600 'niri msg action power-off-monitors' \
        resume 'niri msg action power-on-monitors' \
    before-sleep 'swaylock -f' &

RUST_LOG=info chzzkd >/dev/null 2>>"$HOME/.local/state/chzzkd.log" &
