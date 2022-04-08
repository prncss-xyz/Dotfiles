#!/usr/bin/env sh

mkdir -p "$PASSWORD_STORE_DIR/.extensions/"
wget https://raw.githubusercontent.com/ficoos/pass-fzf/master/fzf.bash -O "$PASSWORD_STORE_DIR/.extensions/fzf.bash"
chmod +x "$PASSWORD_STORE_DIR/.extensions/fzf.bash"
