#!/usr/bin/env sh

sudo systemctl enable bluetooth
sudo systemctl enable iwd
sudo systemctl enable sshd

systemctl --user enable foot-server
systemctl --user enable wlsunset
systemctl --user enable udiskie
systemctl --user enable waybar
systemctl --user enable syncthing
systemctl --user enable mako
systemctl --user enable flashfocus
# systemctl --user enable kdeconnect-sms
# systemctl --user enable kdeconnect-app
systemctl --user enable sway-mega-hotkeys
