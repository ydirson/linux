#!/bin/sh
set -ex

rm -rf TMP
rm -f ~/kernel/modules.img ~/kernel/initramfs ~/kernel/vmlinuz

make "$@" bzImage modules

make "$@" modules_install INSTALL_MOD_PATH=$PWD/TMP

# "sudo dracut" requested by ldconfig and fsfreeze (!?)
kernelrelease=$(cd TMP/lib/modules && echo *)
PATH="/sbin:$PATH" sudo dracut -v --nomdadmconf --nolvmconf \
    --kmoddir TMP/lib/modules/"$kernelrelease" \
    --modules "kernel-modules qubes-vm-simple" \
    --conf /dev/null --confdir /var/empty \
    -d "xenblk xen-blkfront cdrom ext4 jbd2 crc16 dm_snapshot" \
    TMP/lib/modules/initramfs "$kernelrelease"
sudo chown $USER TMP/lib/modules/initramfs

ln arch/x86/boot/bzImage TMP/lib/modules/vmlinuz
ln TMP/lib/modules/vmlinuz TMP/lib/modules/initramfs ~/kernel/

PATH="/sbin:$PATH" mkfs.ext3 -d ./TMP/lib/modules -U dcee2318-92bd-47a5-a15d-e79d1412cdce ~/kernel/modules.img 1024M
