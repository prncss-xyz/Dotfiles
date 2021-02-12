curl https://raw.githubusercontent.com/dschrempf/syncthing-resolve-conflicts/master/syncthing-resolve-conflicts --output ~/bin/syncthing-resolve-conflicts
mkdir -p ~/.config/systemd/user
chmod +x ~/bin/syncthing-resolve-conflicts
curl https://raw.githubusercontent.com/syncthing/syncthing/main/etc/linux-systemd/user/syncthing.service --output ~/.config/systemd/user/Syncthing/etc/linux-systemd/system/syncthing@.service
systemctl --user enable syncthing.service
systemctl --user start syncthing.service
# syncthing -reset-database
# journalctl -e --user-unit=syncthing.service
