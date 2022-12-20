#
# HAKONIWA configuration
#

# Automatically get VM base images from the Internet
AUTO_GET_IMAGES=yes

# 4.2.0, 4.3.0 or 5.1.0
CUMULUS_VERSION=5.1.0

# 9, 10, 11
DEBIAN_VERSION=11

# 20.04
UBUNTU_VERSION=20.04

# if yes, run ssh-keygen -R by make destroy
AUTO_REMOVE_HOST_KEYS=no

# if yes, copy your ssh public key into VMs.
AUTO_INSTALL_AUTHORIZED_KEYS=no
