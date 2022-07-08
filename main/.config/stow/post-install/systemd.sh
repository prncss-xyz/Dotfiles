#!/usr/bin/env sh

sudo systemctl enable lightdm
sudo systemctl enable bluetooth
sudo systemctl enable NetworkManager
sudo systemctl enable avahi
sudo systemctl enable sshd
sudo systemctl enable earlyoom

systemctl --user enable psd
systemctl --user enable wlsunset
systemctl --user enable udiskie
systemctl --user enable waybar
systemctl --user enable syncthing
systemctl --user enable systembus-notify
systemctl --user enable mako
systemctl --user enable flashfocus
systemctl --user enable blueberry-tray
# systemctl --user enable kdeconnect-sms
# systemctl --user enable kdeconnect-app
systemctl --user enable sway-mega-hotkeys
