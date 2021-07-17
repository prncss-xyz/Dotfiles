dir=$(mktemp -d)
cd $dir
git clone --depth=1 https://aur.archlinx.org/yay.git
cd yay
makepkg -si
rm -rf $dir
cat yay | xargs yay --needed --noconfirm -S

cd "$HOME/Stow"
main/.local/bin/stow-all
main/.local/bin/update-sysfiles
main/.local/bin/post-install
