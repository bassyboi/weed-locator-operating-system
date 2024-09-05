# Using Ubuntu 20.04 as the base image
FROM ubuntu:20.04

# Avoid interactive prompts from apt
ARG DEBIAN_FRONTEND=noninteractive

# Update package lists and upgrade packages
RUN apt-get update && apt-get upgrade -y

# Install necessary packages in multiple steps to catch errors
RUN apt-get install -y parted || { echo "Failed to install parted"; exit 1; }
RUN apt-get install -y dosfstools || { echo "Failed to install dosfstools"; exit 1; }
RUN apt-get install -y e2fsprogs || { echo "Failed to install e2fsprogs"; exit 1; }
RUN apt-get install -y util-linux || { echo "Failed to install util-linux"; exit 1; }
RUN apt-get install -y qemu-utils || { echo "Failed to install qemu-utils"; exit 1; }
RUN apt-get install -y xz-utils || { echo "Failed to install xz-utils"; exit 1; }  # Added xz-utils for handling compressed files

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /workspace

# Copy the image creation script into the container
COPY create_image.sh /workspace/create_image.sh

# Ensure the script is executable
RUN chmod +x /workspace/create_image.sh

# Default command to run when starting the container
CMD ["/workspace/create_image.sh"]