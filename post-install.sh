# shellcheck shell=sh
cd ~/Dotfiles/stow || exit 1
stow stow host-"$(hostname)" main perso bindings-qwerty

dir=$(mktemp -d)
cd "$dir" || exit 1
git clone --depth=1 https://aur.archlinux.org/yay.git
cd yay || exit 1
makepkg -si
cat ~/.config/stow/arch/* | xargs yay --needed --noconfirm -S
rm -rf "$dir"
cat ~/.config/stow/post-install/* | sh
