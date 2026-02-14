#!/usr/bin/env bash

# FaceTime HD Driver Installation Script for BlueBuild
# Installs drivers from patjak/facetimehd repository

set -oue pipefail

echo "Installing FaceTime HD drivers..."

# Install build dependencies
echo "Installing build dependencies..."
dnf5 install -y \
    kernel-devel \
    kernel-headers \
    gcc \
    make \
    git \
    curl \
    xz \
    cpio

# Clone and build
echo "Cloning repository..."
git clone https://github.com/patjak/facetimehd.git /tmp/facetimehd

cd /tmp/facetimehd

# Build kernel module
echo "Building kernel module..."
make

# Install kernel module
echo "Installing kernel module..."
make install

# Build and install firmware
echo "Building and installing firmware..."
cd firmware
make

mkdir -p /usr/lib/firmware/facetimehd
cp firmware.bin /usr/lib/firmware/facetimehd/

# Run depmod for all kernels
echo "Running depmod..."
for kver in /lib/modules/*; do
    if [ -d "$kver" ]; then
        depmod -a "$(basename "$kver")" || true
    fi
done

# Configure module loading
echo "Configuring module autoload..."
mkdir -p /etc/modules-load.d
echo "facetimehd" > /etc/modules-load.d/facetimehd.conf

# Cleanup build dependencies
echo "Cleaning up build dependencies..."
dnf5 uninstall -y \
    kernel-devel \
    kernel-headers \
    gcc \
    make \
    git \
    curl \
    xz \
    cpio

# Remove temporary files
cd /
rm -rf /tmp/facetimehd

echo "FaceTime HD drivers installed successfully!"
