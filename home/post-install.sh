## Input fonts
mkdir ~/.fonts
unzip ~/Media/Assets/Input-Font.zip -x /Input_Fonts/ -d ~/.fonts
fc-cache -fv

## Chromium
preferences_dir_path=~/.config/chromium/Default/Extensions
install_chrome_extension () {
  pref_file_path="$preferences_dir_path/$1.json"
  upd_url="https://clients2.google.com/service/update2/crx"
  mkdir -p "$preferences_dir_path"
  echo "{" > "$pref_file_path"
  echo "  \"external_update_url\": \"$upd_url\"" >> "$pref_file_path"
  echo "}" >> "$pref_file_path"
  echo Added \""$pref_file_path"\" ["$2"]
}

install_chrome_extension cfhdojbkjhnklbpkdaibdccddilifddb "uBlock Origin"
install_chrome_extension cjpalhdlnbpafiamejdnhcphjbkeiagm "uBlock Origin"
install_chrome_extension kcpnkledgcbobhkgimpbmejgockkplob "Tracking Token Stripper"

install_chrome_extension gcbommkclmclpchllfjekcdonpmejbdp "HTTPS Everywhere"
install_chrome_extension pkehgijcmpdhfbdbbnkijodmdjhbjlgp "Privacy Badger"
install_chrome_extension fmkadmapgofadopljbjfkapdkoienihi "React Developer Tools"
install_chrome_extension dbepggeogbaibhgnhhndojpepiihcmeb "Vimium"

## Fish

fish -c "fisher update"
ln -s /usr/share/nnn/quitcd/quitcd.fish .config/fish/functions/

## MPD

mkdir -p ~/Music
mkdir -p ~/.mpd/playlists


## Syncthing resolve conflicts

curl https://raw.githubusercontent.com/dschrempf/syncthing-resolve-conflicts/master/syncthing-resolve-conflicts --output ~/bin/syncthing-resolve-conflicts
mkdir -p ~/.config/systemd/user
chmod +x ~/bin/syncthing-resolve-conflicts
ln -s /usr/lib/systemd/user/syncthing.service ~/.config/systemd/user/
systemctl --user enable syncthing.service
systemctl --user start syncthing.service
# syncthing -reset-database
# journalctl -e --user-unit=syncthing.service

## Enable user services
