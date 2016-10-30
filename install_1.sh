# Arch Linux; UEFI, Encrypted FS; Simple partition layout; No swap;
# Official installation guide: https://wiki.archlinux.org/index.php/Installation_Guide

# TODO: loadkeys de-latin1-nodeadkeys, wifi-menu and curl -O <THESESCRIPTS>

# Create partitions (TODO: are your sure, etc...)
(
# New partition table
echo o
# New partition (EFI)
echo n
echo
echo +512M
echo fe00
# New partition (Boot)
echo n
echo
echo +512M
echo
# New partition (LUKS)
echo
echo
echo
echo w
) | gdisk /dev/sda

mkfs.fat -F32 /dev/sda1
mkfs.ext2 /dev/sda2

# Setup the encryption of the system
cryptsetup -c aes-xts-plain64 -s 256 -y -h sha512 luksFormat /dev/sda3
cryptsetup luksOpen /dev/sda3 luks

# Create encrypted partitions
pvcreate /dev/mapper/luks
vgcreate vg0 /dev/mapper/luks
lvcreate -l +100%FREE vg0 --name root

# Create filesystems on encrypted partitions
mkfs.ext4 /dev/mapper/vg0-root

# Mount the new system
mount /dev/mapper/vg0-root /mnt

mkdir /mnt/boot
mount /dev/sda2 /mnt/boot

mkdir /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi

pacstrap /mnt base base-devel grub-efi-x86_64 efibootmgr vim zsh git

genfstab -pU /mnt >> /mnt/etc/fstab

# Make /tmp a ramdisk
echo "tmpfs /tmp tmpfs defaults,noatime,mode=1777 0 0" >> /mnt/etc/fstab

echo "----------------------"
echo "Manual: Change \"relatime\" on all non-boot partitions to \"noatime\"  in /etc/fstab (reduces wear if using an SSD)"
echo "----------------------"
