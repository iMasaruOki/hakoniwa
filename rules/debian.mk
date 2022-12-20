.PHONY: get-debian-image

get-debian-image: ${IMAGEDIR}/debian-${DEBIAN_VERSION}.qcow2

${IMAGEDIR}/debian-${DEBIAN_VERSION}.qcow2: authorized_keys
	mkdir -p images
	sudo virt-builder $$(basename $@ .qcow2) \
	     --format qcow2 \
	     --hostname debian \
	     --root-password password:hogehoge \
	     --install sudo \
	     --run-command 'useradd -m -G sudo,operator -s /bin/bash debian' \
	     --run-command 'chage -M -1 debian' \
	     --mkdir /home/debian/.ssh \
	     --copy-in authorized_keys:/home/debian/.ssh \
	     --chmod 0700:/home/debian/.ssh \
	     --edit '/etc/network/interfaces: s/ens2/ens3/' \
	     --firstboot-command " \
	     env DEBIAN_FRONTEND=noninteractive dpkg-reconfigure openssh-server; \
	     chown -R debian /home/debian; \
	     perl -pi -e 's/^%sudo.*$/%sudo	ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers; \
	     localectl set-keymap jp \
	     " \
	     -o $@; \
	sudo chown $$USER.$$GID $@; \
	echo "$@: Default username is debian and password is hogehoge"

