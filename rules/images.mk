IMAGES=ubuntu debian cumulus sonic

images: $(IMAGES)

$(IMAGES): %:
ifeq (${AUTO_GET_IMAGES},yes)
	-mkdir -p images
	$(MAKE) get-$@-image
endif
