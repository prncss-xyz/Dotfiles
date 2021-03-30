dir=$(mktemp -d)
cd $dir
git clone --depth=1 https://aur.archlinx.org/yay.git
cd yay
makepkg -si
rm -rf $dir
cat yay | xargs yay --needed --noconfirm -S

cd "$HOME/Stow"
base/.local/bin/stow-all
base/.local/bin/update-root
base/.local/bin/post-install

