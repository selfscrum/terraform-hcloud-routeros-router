#
# terraform-hcloud-routeros-router/main.tf - provide a hcloud_server-based RouterOS router.
#
#                                            Creates a Hetzner server in rescue mode, installs a Mikrotek boot image
#                                            and sets up a proper admin user
#                                            -written by selfscrum. C 2020, MIT-Licence
#
#

terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
  }
  required_version = ">= 0.13"
}

###
# the router machine
#

resource "hcloud_server" "router" {
  name        = format("%s-%s-router", var.system_stage, var.system_name)
  image       = "ubuntu-18.04"      # doesn't matter since it will vanish anyway behind the router partition
  server_type = var.router_type
  location    = var.location
  ssh_keys    = [ var.server_key ]
  rescue      = "linux64"
  labels      = {
      "Name"   = var.system_name
      "Stage"  = var.system_stage
      "ROUTER" = true
  }

  # transfer the bootstrap script
  provisioner "file" {
    source      = format ("%s/install_router.sh", path.module)
    destination = "/tmp/install_router.sh"

    connection {
      type        = "ssh"
      user        = "root"
      private_key = var.private_key
      host        = self.ipv4_address
    }
  }  

  # run the bootstrap script
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_router.sh",
      "/tmp/install_router.sh"
    ]

    connection {
      type     = "ssh"
      user     = "root"
      private_key = var.private_key
      host     = self.ipv4_address
    }
  }  
  
  # configure the router - set new user and remove admin
  provisioner "local-exec" {
      command = format("chmod +x %s/access_router.sh ; %s/access_router.sh %s %s %s", 
                        path.module,
                        path.module,
                        self.ipv4_address, 
                        var.router_user,
                        var.router_password
                      )
  }
}
