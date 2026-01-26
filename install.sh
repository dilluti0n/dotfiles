#!/bin/bash

pushd ~/.config
mkdir -p sway kanshi waybar
popd

ln -sf ./sway/config ~/.config/sway/config
ln -sf ./waybar ~/.config/waybar
ln -sf ./kanshi/config ~/.config/kanshi/config
