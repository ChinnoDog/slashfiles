# Targets that are primarily useful on partypants

ifeq ($(HOSTNAME),partypants)

GRUBCFG := /boot/efi/EFI/debian/grub.cfg

$(HOSTNAME): FORCE $(GRUBCFG)

$(GRUBCFG): $(THIS_MAKEFILE)
	UUIDS="$$(for i in 0 1; do blkid -s UUID -o value /dev/nvme$${i}n1p2 | tr -d "-"; done)"
	UUID1=$$(grub-probe --target=cryptodisk_uuid /boot)
	UUID2=$$(echo "$$UUIDS" | grep -v "$$UUID1")
	ROOT_UUID=$$(blkid -s UUID -o value /dev/mapper/crypt0 | tr -d '-')
	INSMODS="$$(bash -i -c 'source /usr/lib/grub/grub-mkconfig_lib; prepare_grub_to_access_device /dev/mapper/crypt0 | grep insmod')"
	mkdir -p $$(dirname $@)
	cat > "$@" <<EOF
	insmod all_video
	insmod efi_gop
	insmod efi_uga
	insmod vbe
	insmod disk
	insmod scsi
	insmod ahci
	insmod usb
	insmod usbms
	insmod search
	insmod search_fs_uuid
	insmod ext2
	insmod loopback
	$$INSMODS
	search --file --set=imgdev /crypto-keyfile.img
	loopback loop "($imgdev)/crypto-keyfile.img"
	cryptomount -l loop || echo "Failed to unlock key container"
	cryptomount -u $$UUID1 -k "(crypto0)/crypto-keyfile.bin" || echo "Failed to unlock crypt0"
	cryptomount -u $$UUID2 -k "(crypto0)/crypto-keyfile.bin" || echo "Failed to unlock crypt1"
	set root='cryptouuid/$$ROOT_UUID'
	set prefix=(\$$root)/@/boot/grub
	configfile \$$prefix/grub.cfg
	EOF

endif
