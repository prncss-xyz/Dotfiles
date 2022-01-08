# shellcheck shell=sh
set -e

USER1=prncss
GIT=https://github.com/prncss-xyz/Dotfiles
if [ -z "$USER1" ]; then echo USER1 not defined
fi
	exit 1
if [ -z "$GIT" ]; then
	echo GIT not defined
	exit 1
fi
if [ -z "$HOSTNAME" ]; then
	echo HOSTNAME not defined
	exit 1
fi

pacstrap /mnt linux linux-firmware base base-devel git stow fscrypt

genfstab -U /mnt >>/mnt/etc/fstab
arch-chroot /mnt

timedatectl set-ntp true
hwclock --systohc
# ln -sf /dev/null /etc/pacman.d/hooks/90-mkinitcpio-install.hook
# ln -sf /dev/null /etc/pacman.d/hooks/60-mkinitcpio-remove.hook
fscrypt setup
fscrypt setup /home

echo "wheel ALL=(ALL) ALL">>/etc/sudoers
useradd -mU -k /empty -G input,lp,users "$USER1"
passwd $USER1
cd /home/"$USER1" || exit 1
rm /home/"$USER1"/.*
sudo -u "$USER1" git clone "$GIT"
sudo -u "$USER1" sh Dotfiles/post-install.sh
