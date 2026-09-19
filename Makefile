STOW := stow
PKGS := $(patsubst %/,%,$(wildcard */))
GUI_DEPS := mako foot bash yt-dlp xdg emacs vim git swaylock halloy chzzkd eww

all: niri

$(PKGS):
	$(STOW) $@

mail: msmtp

emacs: mail

sway: kanshi $(GUI_DEPS)

niri: $(GUI_DEPS)

unstow:
	$(STOW) -D $(PKGS)

.PHONY: all mail unstow $(PKGS)
