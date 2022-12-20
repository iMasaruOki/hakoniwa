# for test simple bgp

locals {
  hosts = {
       "guest"   = { "os" = "ubuntu",  "net" = [ "default", "net0" ] }
       "sonic"   = { "os" = "sonic",   "net" = [ "default", "net0", "net1" ] }
       "cumulus" = { "os" = "cumulus", "net" = [ "default", "net1", "net2" ] }
       "server"  = { "os" = "debian",  "net" = [ "default", "net2" ], "mem" = "8192" }
  }
}
