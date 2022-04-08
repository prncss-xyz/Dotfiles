#!/usr/bin/env sh

sudo systemctl enable lightdm
sudo systemctl enable bluetooth
sudo systemctl enable NetworkManager
sudo systemctl enable avahi
sudo systemctl enable sshd
sudo systemctl enable earlyoom

systemctl --user enable psd
systemctl --user enable syncthing
systemctl --user enable udiskie