# Targets that are primarily useful on partypants

ifeq ($(HOSTNAME),partypants)

$(HOSTNAME): FORCE /etc/slashfiles/local/grub.cfg

/etc/slashfiles/local/grub.cfg: $(THIS_MAKEFILE)
	UUIDS="$$(for i in 0 1; do blkid -s UUID -o value /dev/nvme$${i}n1p2 | tr -d "-"; done)"
	UUID1=$$(grub-probe --target=cryptodisk_uuid /boot)
	UUID2=$$(echo "$$UUIDS" | grep -v "$$UUID1")
	mkdir -p $$(dirname $@)
	cat > "$@" <<EOF
	cryptomount -u $$UUID1
	cryptomount -u $$UUID2
	set root=(crypto0)
	set prefix=(\$$root)/@/grub
	configfile \$$prefix/grub.cfg
	EOF

endif
