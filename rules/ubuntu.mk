.PHONY: get-ubuntu-image

get-ubuntu-image: ${IMAGEDIR}/ubuntu-${UBUNTU_VERSION}.qcow2

${IMAGEDIR}/ubuntu-${UBUNTU_VERSION}.qcow2: authorized_keys
	mkdir -p images
	sudo virt-builder $$(basename $@ .qcow2) \
	     --format qcow2 \
	     --hostname ubuntu \
	     --root-password password:hogehoge \
	     --run-command 'useradd -m -G sudo,operator -s /bin/bash ubuntu' \
	     --run-command 'chage -M -1 ubuntu' \
	     --password ubuntu:password:hogehoge \
	     --run-command "perl -pi -e 's|^%sudo.*$$|%sudo	ALL=(ALL:ALL) NOPASSWD: ALL|' /etc/sudoers" \
	     --mkdir /home/ubuntu/.ssh \
	     --copy-in authorized_keys:/home/ubuntu/.ssh \
	     --chmod 0700:/home/ubuntu/.ssh \
	     --run-command 'chown -R ubuntu /home/ubuntu/.ssh' \
	     --edit '/etc/netplan/01-netcfg.yaml: s/enp1s0/ens3/' \
	     --delete '/etc/machine-id' \
	     --run-command 'touch /etc/machine-id' \
	     --edit '/etc/default/grub: s/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="console=tty0 console=ttyS0,115200"/' \
	     --run-command 'update-grub' \
	     --firstboot-command " \
	     env DEBIAN_FRONTEND=noninteractive dpkg-reconfigure openssh-server; \
	     localectl set-keymap jp \
	     " \
	     -o $@; \
	sudo chown $$USER.$$GID $@; \
	echo "$@: Default username is ubuntu and password is hogehoge"
