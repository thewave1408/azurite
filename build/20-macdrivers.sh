
#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

###############################################################################
# Example: Installing 1Password and Google Chrome from Official Repositories
###############################################################################
# This is an EXAMPLE file showing how to add third-party RPM repositories
# and install packages from them following Universal Blue/Bluefin conventions.
#
# To use this script:
# 1. Rename this file to remove the .example extension: 20-onepassword.sh
# 2. The build system will automatically run scripts in numerical order
#
# IMPORTANT CONVENTIONS (from @ublue-os/bluefin):
# - Always clean up temporary repository files after installation
# - Use dnf5 exclusively (never dnf or yum)
# - Always use -y flag for non-interactive operations
# - Remove repo files to keep the image clean (repos don't work at runtime)
###############################################################################

### Install FacetimeHD from Fedora COPR
echo "Installing FacetimeHD driver..."

# Download Firmware
echo 'install_items+=" /usr/lib/firmware/facetimehd/firmware.bin "' >> /etc/dracut.conf.d/facetimehd.conf

# Enable repository
dnf5 copr enable frgt10/facetimehd-dkms

# Install DKMS driver
dnf5 install -y facetimehd

# Clean up repo file (required - repos don't work at runtime in bootc images)
#rm -f /etc/yum.repos.d/google-chrome.repo

echo "FacetimeHD driver installation complete!"
