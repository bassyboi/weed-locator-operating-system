#!/bin/bash

# Exit on any error
set -e

# Install necessary tools
sudo apt-get update
sudo apt-get install -y git bc bison flex libssl-dev make libc6-dev-armhf-cross gcc-arm-linux-gnueabihf

# Clone the Raspberry Pi Linux kernel source
git clone --depth=1 https://github.com/raspberrypi/linux.git
cd linux

# Set default configuration for Raspberry Pi 4
KERNEL=kernel7l
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcm2711_defconfig

# Customize the kernel configuration
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- menuconfig

# Compile the kernel, modules, and device tree blobs
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage modules dtbs -j$(nproc)

# Install modules to a temporary directory
mkdir -p ../modules
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_PATH=../modules modules_install

echo "Kernel build complete."
