STOW := stow
PKGS := $(patsubst %/,%,$(wildcard */))
GUI_DEPS := mako foot bash yt-dlp xdg waybar emacs vim git swaylock

.PHONY: all
all: niri

.PHONY: $(PKGS)
$(PKGS):
	$(STOW) $@

.PHONY: mail
mail: msmtp mbsync

emacs: mail

sway: $(GUI_DEPS)

niri: kanshi $(GUI_DEPS)

.PHONY: unstow
unstow:
	$(STOW) -D $(PKGS)
