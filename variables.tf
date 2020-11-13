#
# terraform-hcloud-routeros-router/variables.tf - input declarations for the terraform-hcloud-routeros-router module
#                                                 -written by selfscrum. C 2020, MIT-Licence
#
#

variable "system_name"  { 
    description = "System name, used as part of the router name"
}

variable "system_stage" { 
    description = "System stage, used as part of the router name"
}

variable "router_type" {
    description = "Hetzner server type for the machine that will host the router"
}

variable "location" { 
    description = "Hetzner location code for the machine that will host the router"
}

variable "server_key" {
    description = "Hetzner SSH Key Name for the machine that will host the router"
}

variable "private_key" {
    description = "Private key in PEM format for the machine"
}

variable "router_user" {
    description = "Name of the future admin user of the router which will replace 'admin'"
}

variable "router_password" {
    description = "Password of the created future user of the router."
}
