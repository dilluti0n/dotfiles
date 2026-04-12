STOW := stow
GUI_DEPS := mako foot bash yt-dlp xdg waybar emacs vim git swaylock
PKGS := $(GUI_DEPS) sway niri kanshi msmtp mutt

.PHONY: all
all: niri

.PHONY: $(PKGS)
$(PKGS):
	$(STOW) $@

emacs: msmtp

sway: $(GUI_DEPS)

niri: kanshi $(GUI_DEPS)

.PHONY: unstow
unstow:
	$(STOW) -D $(PKGS)
