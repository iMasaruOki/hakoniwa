# make testbed environment

TOPDIR=${PWD}
TFDIR=tf
CONFIGDIR=config
IMAGEDIR=images

all:
	@echo Usage:
	@echo " $(MAKE) setup      - Install several tools and VM images."
	@echo " $(MAKE) config     - Select configuration."
	@echo " $(MAKE) plan       - View plan to build VM images and run VM."
	@echo " $(MAKE) validate   - Validate syntax."
	@echo " $(MAKE) apply      - Build VM images and run VM."
	@echo " $(MAKE) show       - Show current state."
	@echo " $(MAKE) show-hosts - Show running virtual machines."
	@echo " $(MAKE) destroy    - Destroy VM images."

#
#
#

include rules/ansible.mk
include rules/authorized_keys.mk
include rules/config.mk
include rules/cumulus.mk
include rules/debian.mk
include rules/images.mk
include rules/kvm.mk
include rules/libvirtd.mk
include rules/rules.mk
include rules/sonic.mk
include rules/terraform.mk
include rules/tools.mk
include rules/ubuntu.mk
include rules/virt-builder.mk
