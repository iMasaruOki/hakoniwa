# Declare OS image files.
locals {
  image_src = {
    "sonic"   = "sonic-vs.img",
    "debian"  = "debian-11.qcow2",
    "ubuntu"  = "ubuntu-20.04.qcow2",
    "cumulus" = "cumulus-linux-5.1.0-vx-amd64-qemu.qcow2"
  }
}
