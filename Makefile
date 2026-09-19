STOW := stow
PKGS := $(patsubst %/,%,$(wildcard */))
GUI_DEPS := mako foot bash yt-dlp xdg emacs vim git swaylock halloy chzzkd eww

.PHONY: all
all: niri

.PHONY: $(PKGS)
$(PKGS):
	$(STOW) $@

.PHONY: mail
mail: msmtp

emacs: mail

sway: kanshi $(GUI_DEPS)

niri: $(GUI_DEPS)

.PHONY: unstow
unstow:
	$(STOW) -D $(PKGS)
