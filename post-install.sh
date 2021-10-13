# shellcheck shell=sh


HOSTNAME="${HOSTNAME-$hostname}"

cd ~/Dotfiles/stow || exit 1 # on a fresh install, stow will take config info from current dir
stow stow host-"$HOSTNAME" main extra perso bindings-qwerty
sudo pacman -Sy

dir=$(mktemp -d)
cd "$dir" || exit 1
git clone --depth=1 https://aur.archlinux.org/yay.git
cd yay || exit 1
makepkg -si
rm -rf "$dir"

cat ~/.config/stow/arch/* | xargs yay --batchinstall --needed --noconfirm -S
~/Dotfiles/main/.local/bin/setup-theme
sudo rsync -Lr ~/.config/stow/sysfiles/* / # goes after installing packages to avoid file conflicts
sudo locale-gen

cat ~/.config/stow/post-install/*.sh | sh
