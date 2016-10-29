grub-mkconfig -o /boot/grub/grub.cfg

# Exit new system and go into the cd shell
exit

# Unmount all partitions
umount -R /mnt

# Reboot into the new system, don't forget to remove the cd/usb
reboot
