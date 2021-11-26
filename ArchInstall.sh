mkfs.ext4 $rootPartition
mkfs.ext4 $bootPartition
mkswap $swapPartition
swapon $swapPartition
mount $rootPartition /mnt
mkdir /mnt/boot /mnt/var /mnt/home
mount $bootPartition /mnt/boot
pacman -Syy
pacstrap /mnt base base-devel linux linux-firmware nano dhcpcd net-tools grub
genfstab -U /mnt >> /mnt/etc/fstab
echo en_US.UTF-8 UTF-8 >> /mnt/etc/locale.gen
arch-chroot /mnt locale-gen
echo LANG=en_US.UTF-8 > /mnt/etc/locale.conf
arch-chroot /mnt "export LANG=en_US.UTF-8"
ln -s /mnt/usr/share/zoneinfo/Europe/Warsaw /mnt/etc/localtime
arch-chroot /mnt "hwclock --systohc --utc"
echo arch > /mnt/etc/hostname
arch-chroot /mnt "systemctl enable dhcpcd"
echo Wpisz hasło dla root: 
arch-chroot /mnt passwd
arch-chroot /mnt "useradd -m -g users -G wheel -s /bin/bash arch"
echo Wpisz hasło dla użytkownika arch: 
arch-chroot /mnt "passwd debugpoint"
echo "arch ALL=(ALL) ALL" >> /mnt/etc/sudoers
arch-chroot /mnt "grub-install $diskPath"
arch-chroot /mnt "grub-mkconfig -o /boot/grub/grub.cfg"
arch-chroot /mnt "mkinitcpio -p linux"
umount /mnt/boot
umount /mnt
reboot
