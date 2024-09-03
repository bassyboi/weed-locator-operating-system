# Using Ubuntu 20.04 as the base image
FROM ubuntu:20.04

# Avoid interactive prompts from apt
ARG DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && apt-get install -y \
    parted \
    dosfstools \
    e2fsprogs \
    util-linux \
    qemu-utils \
    losetup \
    mkfs.ext4

# Set the working directory in the container
WORKDIR /workspace

# Copy the image creation script into the container
COPY image/create_image.sh /workspace/create_image.sh

# Ensure the script is executable
RUN chmod +x /workspace/create_image.sh

# Default command to run when starting the container
CMD ["/workspace/create_image.sh"]
