dir=$(mktemp -d)
cd $dir
git clone --depth=1 https://aur.archlinx.org/yay.git
cd yay
makepkg -si
rm -rf $dir
cat yay | xargs yay --needed --noconfirm -S

fisher update

cat > $HOME/.config/user-dirs.dirs << EOF
XDG_DOWNLOAD_DIR="$HOME/Downloads"
XDG_PICTURES_DIR="$HOME/Media/Pictures"
XDG_TEMPLATES_DIR="$HOME/Templates"
XDG_DESKTOP_DIR="$HOME/Desktop"
XDG_PUBLICSHARE_DIR="$HOME/Public"
XDG_DOCUMENTS_DIR="$HOME/Media/Documents"
XDG_MUSIC_DIR="$HOME/Music"
XDG_VIDEOS_DIR="$HOME/Videos"
EOF

git config --global init.defaultBranch main
git config --global core.editor "nvr --remote-wait-silet"
git config --global diff.tool nvr
git config --global difftool.nvr.cmd "nvr -s -d \$LOCAL \$REMOTE"
git config --global merge.tool nvr
git config --global mergetool.nvr.cmd "nvr -s -d \$LOCAL \$BASE \$REMOTE \$MERGED -c 'wincmd J| wincmd ='"

/usr/share/qutebrowser/scripts/dictcli.py install en-US
/usr/share/qutebrowser/scripts/dictcli.py install fr-CA

systemctl --user enable ssh-agent.service
systemctl --user enable syncthing.service
systemctl --user enable udiskie.service
pacman -S --needed base-devel git stow

## pnpm
# none seem to work :-(, will retry on fresh install

pnpm config set global-dir ~/.pnpm-packages
pnpm config set set pnpm-prefix ~/.pnpm-packages
pnpm config set set npm-prefix ~/.pnpm-packages

#set NPM_PACKAGES "$HOME/.npm-packages"
#set PATH $PATH $NPM_PACKAGES/bin
#set MANPATH $NPM_PACKAGES/share/man $MANPATH

broot --install
