.PHONY: get-cumulus-image

CUMULUS_5.1.0_URL="https://d2cd9e7ca6hntp.cloudfront.net/public/CumulusLinux-5.1.0/cumulus-linux-5.1.0-vx-amd64-qemu.qcow2"
CUMULUS_4.3.0_URL="https://d2cd9e7ca6hntp.cloudfront.net/public/CumulusLinux-4.3.0/cumulus-linux-4.3.0-vx-amd64-qemu.qcow2"
CUMULUS_4.2.0_URL="https://d2cd9e7ca6hntp.cloudfront.net/public/CumulusLinux-4.2.0/cumulus-linux-4.2.0-vx-amd64-qemu.qcow2"
CUMULUS_URL=${CUMULUS_${CUMULUS_VERSION}_URL}

get-cumulus-image: ${IMAGEDIR}/cumulus-linux-${CUMULUS_VERSION}-vx-amd64-qemu.qcow2

${IMAGEDIR}/cumulus-linux-${CUMULUS_VERSION}-vx-amd64-qemu.qcow2: authorized_keys
	cd ${IMAGEDIR}; curl -sS -O ${CUMULUS_URL}
	sudo virt-customize \
	     --edit '/etc/shadow: s/0:0:99999/18458:0:99999/' \
	     --run-command "perl -pi -e 's|^%sudo.*$$|%sudo	ALL=(ALL:ALL) NOPASSWD: ALL|' /etc/sudoers" \
	     --mkdir /home/cumulus/.ssh \
	     --copy-in authorized_keys:/home/cumulus/.ssh \
	     --chmod 0700:/home/cumulus/.ssh \
	     --run-command 'chown -R cumulus /home/cumulus' \
		-a $@
	@echo "$@: Default username is cumulus and password is CumulusLinux!"
