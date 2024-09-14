# Use Ubuntu 20.04 as the base image
FROM ubuntu:20.04

# Set environment variable to avoid interactive prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Set shell
SHELL ["/bin/bash", "-c"]

# Update package lists, upgrade packages, install necessary packages, and clean up in one step
RUN set -e && \
    apt-get update && apt-get upgrade -y && \
    apt-get install -y \
        parted \
        dosfstools \
        e2fsprogs \
        util-linux \
        qemu-utils \
        xz-utils && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /workspace

# Copy the image creation script into the container with execution permissions
COPY --chmod=0755 create_image.sh /workspace/create_image.sh

# Add labels for metadata
LABEL maintainer="Your Name <your.email@example.com>"
LABEL version="1.0"
LABEL description="Docker image for creating custom images using create_image.sh"

# Default command to run when starting the container
ENTRYPOINT ["/workspace/create_image.sh"]
