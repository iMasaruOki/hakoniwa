setup: tools images roles collections init

init:
	cd ${TFDIR}; terraform init

plan:
	cd ${TFDIR}; terraform plan

validate:
	cd ${TFDIR}; terraform validate

apply: ${TFDIR}/config.tf
	@if [ ! -d ${TFDIR}/.terraform ]; then \
		echo Need initialization.; \
		echo Run "make setup" or "make init".; \
		exit 1; \
	fi
	cd ${TFDIR}; terraform apply -auto-approve

show:
	cd ${TFDIR}; terraform show

show-hosts:
	@printf "%10.10s       %s\n" "VM name" "Mgmt IP"
	@for d in $(shell virsh list --name); do \
		printf "%10.10s       " $$d; \
		virsh domifaddr $$d|tail -2|head -1|awk '{print $$4}'; \
	done

destroy: remove-host-keys
	cd ${TFDIR}; terraform destroy -auto-approve
	for dom in $$(virsh list --all --name); do virsh undefine $$dom; done

hosts:
	@test -f ansible/$(shell cat .config)/Makefile && \
	(cd ansible/$(shell cat .config); $(MAKE) -f ./Makefile hosts) | \
	sed -e 's/^make.*$$//g' -e 's/^[^=]*$$//g' -e 's/ ansible_ssh_hosts//g'

remove-host-keys:
ifeq (${AUTO_REMOVE_HOST_KEYS},yes)
	@for ip in $(shell $(MAKE) hosts | sed -e 's/^make.*$$//g' -e 's/^.*=//g'); do ssh-keygen -R $$ip; done
endif

${TFDIR}/config.tf:
	@echo Need configuration.
	@echo Run make config CONFIG=config
	@echo e.g. make config CONFIG=${CONFIGDIR}/simple-network.tf
	@exit 1

config::
	@if [ "x$$CONFIG" = "x" ]; then \
		echo Usage: make config CONFIG=config_file; \
		echo; \
		echo "available configs are:"; \
		ls ${CONFIGDIR}/*; \
		echo; \
		exit 1; \
	fi
	@if [ \! -f $$CONFIG ]; then \
		echo $$CONFIG: no such file or directory.; \
		exit 1; \
	fi
	-mv -f ${TFDIR}/config.tf ${TFDIR}/config.tf.bak
	ln -s ${TOPDIR}/$$CONFIG ${TFDIR}/config.tf
	basename $$CONFIG .tf > .config
