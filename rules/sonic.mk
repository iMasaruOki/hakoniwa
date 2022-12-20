get-sonic-image: ${IMAGEDIR}/sonic-vs.img

${IMAGEDIR}/sonic-vs.img:
ifeq (${AUTO_GET_SONIC},yes)
	echo "Sorry, getting SONiC-VS image automatically are currently not supported."
	echo "Download by your hand, and put sonic-vs.img into images/."
endif
