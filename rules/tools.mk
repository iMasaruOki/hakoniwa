TOOLS=kvm libvirtd virt-builder terraform

tools: $(TOOLS)

$(TOOLS): %:
	@which $@ > /dev/null; if [ $$? != 0 ]; then \
	   $(MAKE) $@-install; \
	fi
