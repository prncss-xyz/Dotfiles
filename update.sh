# shellcheck shell=sh

stow stow host-"$(hostname)" main perso bindings-qwerty
sudo pacman -Sy
cat ~/.config/stow/arch/* | xargs yay --batchinstall --needed --noconfirm -Su
rsync -av --ignore-existing .ssh/* prncss@odonata.local:.ssh/
cat ~/.config/stow/update/*.sh | sh
update-sysfiles
