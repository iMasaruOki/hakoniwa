terraform-install:
	curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
	sudo apt-add-repository "deb [arch=$(shell dpkg --print-architecture)] https://apt.releases.hashicorp.com $(shell lsb_release -cs) main"
	sudo apt update
	sudo apt install -y terraform
