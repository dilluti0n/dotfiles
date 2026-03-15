STOW := stow
GUI_DEPS := mako foot bash yt-dlp xdg waybar emacs vim git
SWAY_DEPS := kanshi $(GUI_DEPS)
NIRI_DEPS := $(GUI_DEPS)
PKGS := $(GUI_DEPS) sway niri kanshi

.PHONY: all
all: niri

.PHONY: $(PKGS)
$(PKGS):
	$(STOW) $@

sway: $(SWAY_DEPS)

niri: $(NIRI_DEPS)

.PHONY: unstow
unstow:
	$(STOW) -D $(PKGS)
