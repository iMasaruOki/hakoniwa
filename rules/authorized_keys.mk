authorized_keys:
ifeq (${AUTO_INSTALL_AUTHORIZED_KEYS},yes)
	if [ -f $$HOME/.ssh/id_rsa.pub ]; then \
	  cp $$HOME/.ssh/id_rsa.pub $@; \
	elif [ -f $HOME/.ssh/authorized_keys ]; then \
	  cp $$HOME/.ssh/authorized_keys $@; \
	fi
endif
	touch $@
