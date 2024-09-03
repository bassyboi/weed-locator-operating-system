#!/bin/bash
set -e

IMG_SIZE=4096
IMG_FILE="custom_rpi_os.img"

# Create an empty image file
dd if=/dev/zero of=$IMG_FILE bs=1M count=$IMG_SIZE

# Create partitions
parted $IMG_FILE mklabel msdos
parted $IMG_FILE mkpart primary fat32 1MiB 256MiB
parted $IMG_FILE mkpart primary ext4 256MiB 100%

# Setup loop devices
LOOP_DEV=$(losetup -f --show $IMG_FILE)
BOOT_PART="${LOOP_DEV}p1"
ROOT_PART="${LOOP_DEV}p2"

# Create filesystems
mkfs.vfat -n BOOT $BOOT_PART
mkfs.ext4 -L rootfs $ROOT_PART

# Mount partitions and copy files
mkdir -p mnt/boot mnt/root
mount $BOOT_PART mnt/boot
mount $ROOT_PART mnt/root

# Copy kernel and device tree files
cp linux/arch/arm/boot/zImage mnt/boot/kernel8.img
cp linux/arch/arm/boot/dts/*.dtb mnt/boot/
cp linux/arch/arm/boot/dts/overlays/*.dtb* mnt/boot/overlays/

# Copy root filesystem
cp -a rootfs/* mnt/root/

# Unmount and detach loop device
umount mnt/boot mnt/root
losetup -d $LOOP_DEV
