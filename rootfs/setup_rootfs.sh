#!/bin/bash

# Exit on any error
set -e

# Install debootstrap for creating a minimal Debian-based filesystem
sudo apt-get update
sudo apt-get install -y debootstrap qemu-user-static

# Create a minimal root filesystem for Raspberry Pi 4 using Debian
TARGET_ROOTFS_DIR="rootfs"
ARCH="armhf"
DISTRO="buster"

sudo debootstrap --arch=$ARCH --foreign $DISTRO $TARGET_ROOTFS_DIR http://deb.debian.org/debian/

# Copy QEMU to chroot for ARM emulation
sudo cp /usr/bin/qemu-arm-static $TARGET_ROOTFS_DIR/usr/bin/

# Enter the chroot environment to complete setup
sudo chroot $TARGET_ROOTFS_DIR /bin/bash -c "
  apt-get update
  apt-get install -y sudo openssh-server net-tools zram-tools
  echo 'root:root' | chpasswd

  # Check if systemctl is available and running
  if command -v systemctl >/dev/null && systemctl | grep -q '\-\.mount'; then
    systemctl disable bluetooth.service
    systemctl disable avahi-daemon.service
  else
    echo 'Systemd is not available. Skipping service disable steps.'
  fi

  apt-get clean
"

echo "Root filesystem setup complete."
