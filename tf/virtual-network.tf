locals {
  virtual_network = [for nic in distinct(flatten([
    for host in local.hosts : host["net"]
  ])) : nic if nic != "default"]
}

resource "libvirt_network" "virtual_network" {
  for_each = toset(local.virtual_network)
  name = each.key
  mode = "none"
  dns { local_only = true }
}
