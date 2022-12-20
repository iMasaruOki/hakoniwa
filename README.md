# HAKONIWA, virtual network builder

## Synopsis

HAKONIWA as virtual network builder for Linux host.
You can create VMs and connect VMs via virtual network easily using HAKONIWA.


## Requisite

- Internet reachability
- Terraform
- QEMU, KVM
- libvirt


These tools are installed automatically by `make setup`.

Tested on Ubuntu 20.04 LTS.


## Basic usage

1. `make setup` (once)
2. logout if `libvirt` is installed (once)
3. select configuration such as `config/simple-network.conf`, or your own wrote file.
3. `make config CONFIG=config/simple-network.tf` or specify your own wrote file.
4. `make apply`

For help, type "`make`".


## Example

`simple-network.tf` configuration has 4 VMs and 3 virtual networks.

```
locals {
  hosts = {
       "guest"   = { "os" = "ubuntu",  "net" = [ "default", "net0" ] }
       "sonic"   = { "os" = "sonic",   "net" = [ "default", "net0", "net1" ] }
       "cumulus" = { "os" = "cumulus", "net" = [ "default", "net1", "net2" ] }
       "server"  = { "os" = "ubuntu",  "net" = [ "default", "net2" ] }
  }
}
```

Topology:
---------

```
-------------------
|guest (Ubuntu)   |- - - - -
-------------------         .
         |                  .
       (net0)               .
         |                  .
-------------------         .
|sonic (SONiC-VS) |- - - - -.
-------------------         .
         |                  .         ----------------
       (net1)              (default)--| Host machine |
         |                  .         ----------------
-------------------         .
|cumulus (Cumulus)|- - - - -.
-------------------         .
         |                  .
       (net2)               .
         |                  .
-------------------         .
|server (Ubuntu)  |- - - - -
-------------------
```

Create it
---------

```
$ cat config/simple-network.tf 
# for test simple bgp

locals {
  hosts = {
       "guest"   = { "os" = "ubuntu",  "net" = [ "default", "net0" ] }
       "sonic"   = { "os" = "sonic",   "net" = [ "default", "net0", "net1" ] }
       "cumulus" = { "os" = "cumulus", "net" = [ "default", "net1", "net2" ] }
       "server"  = { "os" = "ubuntu",  "net" = [ "default", "net2" ] }
  }
}
$ make config CONFIG=config/simple-network.tf 
mv -f tf/config.tf tf/config.tf.bak
cp $CONFIG tf/config.tf
basename $CONFIG .tf > .config
$ make apply
cd tf; terraform apply -auto-approve
module.hosts.libvirt_pool.storage-pool: Creating...
libvirt_network.private_network["net1"]: Creating...
libvirt_network.private_network["net2"]: Creating...
libvirt_network.private_network["net0"]: Creating...
module.hosts.libvirt_pool.storage-pool: Creation complete after 5s [id=96b6daf4-e52f-494b-b2fb-820299cbe8c0]
module.hosts.libvirt_volume.os-image["guest"]: Creating...
module.hosts.libvirt_volume.os-image["server"]: Creating...
module.hosts.libvirt_volume.os-image["sonic"]: Creating...
module.hosts.libvirt_volume.os-image["cumulus"]: Creating...
libvirt_network.private_network["net2"]: Creation complete after 5s [id=3a354c97-e2fb-473a-aacd-bcdcb39dcfd8]
libvirt_network.private_network["net1"]: Creation complete after 5s [id=e248e37b-32fb-4476-b205-794353bd2c79]
libvirt_network.private_network["net0"]: Creation complete after 5s [id=55a28d5b-e6c1-4be8-90dd-ef5f8d7ec6eb]
module.hosts.libvirt_volume.os-image["guest"]: Creation complete after 3s [id=/home/masaru/hakoniwa/tf/modules/hosts/pool/guest-disk.qcow2]
module.hosts.libvirt_volume.os-image["server"]: Creation complete after 6s [id=/home/masaru/hakoniwa/tf/modules/hosts/pool/server-disk.qcow2]
module.hosts.libvirt_volume.os-image["sonic"]: Still creating... [10s elapsed]
module.hosts.libvirt_volume.os-image["cumulus"]: Still creating... [10s elapsed]
module.hosts.libvirt_volume.os-image["sonic"]: Still creating... [20s elapsed]
module.hosts.libvirt_volume.os-image["cumulus"]: Still creating... [20s elapsed]
module.hosts.libvirt_volume.os-image["sonic"]: Creation complete after 21s [id=/home/masaru/hakoniwa/tf/modules/hosts/pool/sonic-disk.qcow2]
module.hosts.libvirt_volume.os-image["cumulus"]: Creation complete after 25s [id=/home/masaru/hakoniwa/tf/modules/hosts/pool/cumulus-disk.qcow2]
module.hosts.libvirt_domain.domain-vm["guest"]: Creating...
module.hosts.libvirt_domain.domain-vm["server"]: Creating...
module.hosts.libvirt_domain.domain-vm["cumulus"]: Creating...
module.hosts.libvirt_domain.domain-vm["sonic"]: Creating...
module.hosts.libvirt_domain.domain-vm["guest"]: Creation complete after 1s [id=1262528a-e8db-4de0-abfe-3b0abcb5202e]
module.hosts.libvirt_domain.domain-vm["server"]: Creation complete after 1s [id=9e138c6d-a07f-4281-8e3d-863564eed5c8]
module.hosts.libvirt_domain.domain-vm["sonic"]: Creation complete after 1s [id=52731994-ffd6-4b54-86c7-151b5954436f]
module.hosts.libvirt_domain.domain-vm["cumulus"]: Creation complete after 1s [id=38911941-e516-445e-9a0c-171487f83169]

Apply complete! Resources: 12 added, 0 changed, 0 destroyed.
$ 
```


## How to access VMs

After make apply, To get VM names and mgmt IP address, you can use "make show-hosts".

```
$ make show-hosts
   VM name       Mgmt IP
     sonic       192.168.122.4/24
    server       192.168.122.186/24
     guest       192.168.122.114/24
   cumulus       192.168.122.41/24
```

You can

- `virsh console NAME`
- `ssh IP_ADDRESS`


## VMs and network configuration

Typical host entry format:

```
{ NAME, "os" = OS, "cpu" = NUM, "mem" = NUM, "net" = [ "default", "...", ... ] }
```

host entry parameter:

- NAME
  VM name.
- `"os"`
  OS image name.
  Currentry, one of
  - `"ubuntu"`
  - `"debian"`
  - `"cumulus"`
  - `"sonic"`
- `"cpu"`
  Number of core.
- `"mem"`
  Memory size.  Megabyte.
- `"net"`
  Virtual network names.  Virtual networks are automatically craated.
  `"default"` as management network.


## HAKONIWA configuration

Edit `rules/config/mk`.


## Future plan

- Speficy OS version for each VM
- Customize storage size of VMs
- Configuration VMs by Ansible

## History

- Dec 21, 2022  Initial release

## LICENSE

Apache-2.0
