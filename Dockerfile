# Using Ubuntu 20.04 as the base image
FROM ubuntu:20.04

# Avoid interactive prompts from apt
ARG DEBIAN_FRONTEND=noninteractive

# Update package lists and upgrade packages
RUN apt-get update && apt-get upgrade -y

# Install necessary packages
RUN apt-get install -y \
    parted \
    dosfstools \
    e2fsprogs \
    util-linux \
    qemu-utils \
    xz-utils \  # Add xz-utils in case it's needed for handling .img files
    --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /workspace

# Copy the image creation script into the container
COPY create_image.sh /workspace/create_image.sh

# Ensure the script is executable
RUN chmod +x /workspace/create_image.sh

# Default command to run when starting the container
CMD ["/workspace/create_image.sh"]