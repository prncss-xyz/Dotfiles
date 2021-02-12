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
