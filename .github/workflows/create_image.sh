#!/bin/bash

# Exit on any error
set -e

IMG_SIZE="4096"  # Size in MB for the disk image
IMG_FILE="custom_rpi_os.img"

# Create an empty image file
dd if=/dev/zero of="$IMG_FILE" bs=1M count="$IMG_SIZE"

# Create partitions
parted "$IMG_FILE" --script -- mklabel msdos
parted "$IMG_FILE" --script -- mkpart primary fat32 1MiB 256MiB
parted "$IMG_FILE" --script -- mkpart primary ext4 256MiB 100%

# Setup loop devices
LOOP_DEV=$(sudo losetup -f --show "$IMG_FILE")
BOOT_PART="${LOOP_DEV}p1"
ROOT_PART="${LOOP_DEV}p2"

# Create filesystems
sudo mkfs.vfat -n BOOT "$BOOT_PART"
sudo mkfs.ext4 -L rootfs "$ROOT_PART"

# Mount partitions and copy files
mkdir -p mnt/boot mnt/root
sudo mount "$BOOT_PART" mnt/boot
sudo mount "$ROOT_PART" mnt/root

# Copy kernel and device tree files
sudo cp linux/arch/arm/boot/zImage mnt/boot/kernel8.img
sudo cp linux/arch/arm/boot/dts/*.dtb mnt/boot/
sudo cp linux/arch/arm/boot/dts/overlays/*.dtb* mnt/boot/overlays/

# Copy root filesystem
sudo cp -a rootfs/* mnt/root/

# Unmount and detach loop device
sudo umount mnt/boot mnt/root
sudo losetup -d "$LOOP_DEV"

echo "Bootable image creation complete."