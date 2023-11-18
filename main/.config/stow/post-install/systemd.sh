#!/usr/bin/env sh

sudo systemctl enable bluetooth
sudo systemctl enable gdm
sudo systemctl enable iwd
sudo systemctl enable sshd
sudo systemctl enable networkd
sudo systemctl enable resolved

systemctl --user enable foot-server
systemctl --user enable river-tag-overlay
systemctl --user enable swaybg
systemctl --user enable swayidle
systemctl --user enable way-displays
systemctl --user enable wlsunset
systemctl --user enable udiskie
systemctl --user enable waybar
systemctl --user enable syncthing
systemctl --user enable mako
systemctl --user enable sway-mega-hotkeys
