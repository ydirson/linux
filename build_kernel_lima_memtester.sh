#!/bin/sh

make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- mrproper
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- sun8i_h3_lima_memtester_defconfig
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j4 uImage || exit 1
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- savedefconfig

mv arch/arm/boot/uImage uImage-3.4-sun8i-h3-lima-memtester
