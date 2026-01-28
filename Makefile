STOW := stow
SWAY_DEPS := waybar kanshi mako foot bash yt-dlp
SIMPLE_DEPS := $(SWAY_DEPS) emacs vim git dwm alacritty
PKGS := $(SIMPLE_DEPS) sway

.PHONY: all
all: sway

.PHONY: $(SIMPLE_DEPS) 
$(SIMPLE_DEPS):
	$(STOW) $@

.PHONY: sway
sway: $(SWAY_DEPS)
	$(STOW) $@

.PHONY: unstow
unstow:
	$(STOW) -D $(PKGS)
