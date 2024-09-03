#!/bin/bash
set -e

# Install dependencies
sudo apt-get update
sudo apt-get install -y gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf bc git bison flex libssl-dev make

# Clone Raspberry Pi kernel source
git clone --depth=1 https://github.com/raspberrypi/linux.git
cd linux

# Configure for Raspberry Pi 4
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcm2711_defconfig
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j$(nproc) zImage modules dtbs

# Install modules
mkdir -p ../modules
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_PATH=../modules modules_install
