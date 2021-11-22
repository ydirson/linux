#!/bin/sh
set -ex

MAKE_ARGS="KERNELRELEASE=5.15.4-0.fc32.qubes.x86_64"
make -j8 $MAKE_ARGS bzImage modules
rm -rf TMP
make $MAKE_ARGS modules_install INSTALL_MOD_PATH=$PWD/TMP
ln arch/x86/boot/bzImage TMP/vmlinuz
ln initramfs TMP/
PATH="/sbin:$PATH" mkfs.ext3 -d ./TMP -U dcee2318-92bd-47a5-a15d-e79d1412cdce ~/kernel/modules.img 1024M
