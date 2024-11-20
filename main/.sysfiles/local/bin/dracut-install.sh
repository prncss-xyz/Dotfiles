#!/usr/bin/env sh

while read -r line; do
	if [[ "$line" == 'usr/lib/modules/'+([^/])'/pkgbase' ]]; then
		read -r pkgbase < "/${line}"
		kver="${line#'usr/lib/modules/'}"
		kver="${kver%'/pkgbase'}"
    dracut /boot/efi/EFI/systemd/loader.efi --kver "$kver" --force
	fi
done

