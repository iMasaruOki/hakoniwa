.PHONY: get-sonic-image

get-sonic-image: ${IMAGEDIR}/sonic-vs.img

${IMAGEDIR}/sonic-vs.img:
	mkdir -p images
	curl $(shell curl -s https://sonic.software/builds.json | jq .${SONIC_BRANCH}.\"sonic-vs.img.gz\".url) | gzip -d > $@ || rm $@
