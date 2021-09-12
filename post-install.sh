# shellcheck shell=sh
cd ~/Dotfiles/stow || exit 1 # on a fresh install, stow will take config info there
stow stow host-"$(hostname)" main perso bindings-qwerty
sudo pacman -Sy
dir=$(mktemp -d)
cd "$dir" || exit 1
git clone --depth=1 https://aur.archlinux.org/yay.git
cd yay || exit 1
makepkg -si
cat ~/.config/stow/arch/* | xargs yay --batchinstall --needed --noconfirm -S
rm -rf "$dir"
cat ~/.config/stow/post-install/*.sh|sh

cat > ~/.config/user-dirs.dirs << EOF
XDG_DOWNLOAD_DIR="$HOME/Downloads"
XDG_PICTURES_DIR="$HOME/Media/Pictures"
XDG_TEMPLATES_DIR="$HOME/Templates"
XDG_DESKTOP_DIR="$HOME/Desktop"
XDG_PUBLICSHARE_DIR="$HOME/Public"
XDG_DOCUMENTS_DIR="$HOME/Media/Documents"
XDG_MUSIC_DIR="$HOME/Music"
XDG_VIDEOS_DIR="$HOME/Videos"
EOF

