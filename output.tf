#
# terraform-hcloud-routeros-router/output.tf - returns from the terraform-hcloud-routeros-router module
#                                              -written by selfscrum. C 2020, MIT-Licence
#
#

output "router_ip" {
    description = "IP Address of the created Router"
    value = hcloud_server.router.ipv4_address
}

output "router_id" {
    description = "Hetzner id of the created Router"
    value = hcloud_server.router.id
}
