Dilluti0n's dotfiles
====================

Why hosting this? I don't know. Isn't this like instagram stories for
us? Anyway, these are very dirty, so don't use them in real life.

Notes
-----

My dotfiles are managed by stow, and dependencies (which aren't
properly done) are managed through a Makefile.

I execute .exec-dm (a display manager call script) in .profiles when
the tty is /dev/tty1. For example, niri/.exec-dm is symlinked to
~/.exec-dm and contains exec dbus-run-session niri --session. Through
this, if you want to change the display manager, you simply need to
change the symlinks for it.

Custom scripts are usually placed as functions in .bashrc. If a script
needs to be invoked outside of the terminal session (usually scripts
that need to be called using bemenu), place it in ~/bin/.


vgreb
-----

This is a video download (grab; greb was typo) manager depends on
yt-dlp. It is shell script and save logs to ~/.vgreb/history in TSV
format. The log is used as a relational database for other convenience
functions.

This was basically created to use yt-dlp efficiently in a GUI
environment. I
[set](https://git.dilluti0n.com/dotfiles.git/tree/niri/.config/niri/config.kdl?id=e81904ba12a18293731c3dae4941f1fae63b3d6c#n42)
Mod+y shortcut for following:

    vgreb download $(wl-paste -p)

vgreb sends desktop notifications via notify-send when a download
starts or ends, so it is quite comfortable for grab (or vgreb) some
videos.

You can view it's source code on

    https://git.dilluti0n.com/dotfiles.git/tree/yt-dlp/bin/vgreb

and download it with

    curl https://git.dilluti0n.com/dotfiles.git/plain/yt-dlp/bin/vgreb > vgreb &&
        chmod +x vgreb

Enjoy ^~^
