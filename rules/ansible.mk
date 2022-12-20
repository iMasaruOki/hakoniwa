ansible-install:
	sudo apt update
	sudo apt install -y software-properties-common python-netaddr
	sudo apt-add-repository --yes --update ppa:ansible/ansible
	sudo apt install -y ansible

roles: $(ANSIBLE_ROLES)

collections: $(ANSIBLE_COLLECTIONS)

$(ANSIBLE_COLLECTIONS): % :
	ansible-galaxy collection install $@

$(ANSIBLE_ROLES): % :
	ansible-galaxy install $@
