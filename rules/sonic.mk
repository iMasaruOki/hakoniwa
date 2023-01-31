.PHONY: get-sonic-image

get-sonic-image: ${IMAGEDIR}/sonic-vs.img

${IMAGEDIR}/sonic-vs.img:
	mkdir -p images
	curl $(shell curl -s https://sonic.software/builds.json | jq .${SONIC_BRANCH}.\"sonic-vs.img.gz\".url) | gzip -d > $@ || rm $@
	IMAGEDIR=$$(sudo virt-ls -a $@ -m /dev/sda3 / | grep image); \
	sudo guestfish -a $@ -m /dev/sda3 mkdir-p /$$IMAGEDIR/rw/home/admin/.ssh; \
	sudo guestfish -a $@ -m /dev/sda3 chown 1000 1000 /$$IMAGEDIR/rw/home/admin/.ssh; \
	sudo guestfish -a $@ -m /dev/sda3 copy-in ./authorized_keys /$$IMAGEDIR/rw/home/admin/.ssh/; \
	sudo guestfish -a $@ -m /dev/sda3 chown 1000 1000  /$$IMAGEDIR/rw/home/admin/.ssh/authorized_keys
