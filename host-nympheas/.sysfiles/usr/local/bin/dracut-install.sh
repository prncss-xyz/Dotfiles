#!/usr/bin/env bash

args=('--force' '/boot/efi/EFI/BOOT/BOOTX64.EFI')

while read -r line; do
	if [[ "$line" == 'usr/lib/modules/'+([^/])'/pkgbase' ]]; then
		read -r pkgbase < "/${line}"
		kver="${line#'usr/lib/modules/'}"
		kver="${kver%'/pkgbase'}"

		# install -Dm0644 "/${line%'/pkgbase'}/vmlinuz" "/boot/vmlinuz-${pkgbase}"
		dracut "${args[@]}" --kver "$kver"
	fi
done
