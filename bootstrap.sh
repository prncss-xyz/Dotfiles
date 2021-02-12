pacman -S --needed base-devel

dir=$(mktemp -d)
cd $dir
git clone --depth=1 https://aur.archlinx.org/yay.git
cd yay
makepkg -si
rm -rf $dir

cd "$HOME/stow"
cat */yay|xargs yay --needed --noconfirm -Syu
stow $(ls -d */)
sh */post-install.sh

