arch-chroot /mnt /bin/bash

# Setup system clock
ln -s /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc --utc

# Set the hostname
echo MXi > /etc/hostname

# Update locale
echo LANG=de_DE.UTF-8 >> /etc/locale.conf
echo LANGUAGE=de_DE >> /etc/locale.conf
echo LC_ALL=C >> /etc/locale.conf

# Set password for root
echo "Next: Password for root..."
passwd

# Add real user remove -s flag if you don't whish to use zsh
useradd -m -g users -G wheel -s /bin/zsh duesee

echo "Next: Password for duesee..."
passwd duesee

# Configure mkinitcpio with modules needed for the initrd image
echo "-----"
echo "MANUAL: Add keymap, encrypt and lvm2 to HOOKS before block in /etc/mkinitcpio.conf"
echo "MANUAL: Add i915 to MODULES in /etc/mkinitcpio.conf"
echo "-----"
