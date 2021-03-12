seeds=seeds
set -e
source "$seeds"/vars.sh
if [ -z $HOSTNAME ]
then
  echo hostname expected as argument
  exit 1
fi
if [ -z $USER1 ]
then
  echo user should be defined in seeds/vars.sh
  exit 1
fi
git clone /.dotfiles-root /mnt

clone_file () {
  cp -a --parents "$1" /mnt/"$1"
}
clone_file /root/board.bin

pacstrap /mnt base linux linux-firmware networkmanager sudo vi intel-ucode
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
timedatectl set-ntp true
hwclock --systohc
locale-gen
useradd $USER1
passwd $USER1
echo $USER1 ALL=(ALL) ALL >> /etc/sudoers
echo $HOSTNAME > /etc/hostname
echo << EOF > /etc/hosts
127.0.0.1   localhost
::1         localhost
127.0.1.1   $HOSTNAME.localdomain	$HOSTNAME
EOF
mkinitcpio -P
bootctl install
ROOT_IDING=$(grep '\s/\s' /etc/fstab|cut -f 1)
echo << EOF > /boot/loader/entries/arch.conf
title   Arch Linux
linux   /vmlinuz-linux
initrd  /intel-ucode.img
initrd  /initramfs-linux.img
options root=$ROOT_IDING rw
EOF
echo << EOF > /boot/loader/entries/arch-fallback.conf
title   Arch Linux
linux   /vmlinuz-linux
initrd  /intel-ucode.img
initrd  /initramfs-linux-fallback.img
options root=$ROOT_IDING rw
EOF
systemctl enable NetworkManager
systemctl enable avahi
systemctl enable sshd
systemctl enable greetd
# test if surface go
if [[ 1==1 ]] 
then
  sh /root/update.sh
fi

#reboot

