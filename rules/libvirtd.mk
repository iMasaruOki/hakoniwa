libvirtd-install:
	sudo apt install -y libvirt-clients libvirt-daemon-system
	sudo sed -i 's/^security_driver.*$/security_driver = "none"/' /etc/libvirt/qemu.conf
	sudo usermod -aG libvirt $$USER
