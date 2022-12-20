terraform {
  required_version = ">= 1.3"
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_volume" "os-image" {
  for_each = local.hosts
  name = "${each.key}-disk.qcow2"
  source = "${path.cwd}/../images/${local.image_src[each.value["os"]]}"
  format = "qcow2"
}

resource "libvirt_domain" "domain-vm" {
  for_each = local.hosts
  name = each.key
  memory = lookup(each.value, "mem", null) != null ? each.value["mem"] : 2048
  vcpu =  lookup(each.value, "cpu", null) != null ? each.value["cpu"] : 1

  cpu { mode = "host-passthrough" }
  disk { volume_id = libvirt_volume.os-image[each.key].id }

  dynamic network_interface {
    for_each = each.value["net"]
    content {
      network_name = network_interface.value
      mac = format("52:54:00:12:%02X:%02X",
                   index(keys(local.hosts), each.key),
                   index(each.value["net"], network_interface.value))
    }
  }

  console {
    type = "pty"
    target_port = "0"
  }

  graphics {
    type = "spice"
    listen_type = "address"
    autoport = "true"
  }
}
