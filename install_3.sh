# Configure mkinitcpio with modules needed for the initrd image
vim /etc/mkinitcpio.conf

# Regenerate initrd image
mkinitcpio -p linux

# Setup grub
grub-install

echo "-----"
echo "MANUAL: In /etc/default/grub edit the line GRUB_CMDLINE_LINUX to GRUB_CMDLINE_LINUX=\"cryptdevice=/dev/sda3:luks:allow-discards\""
echo "-----"
