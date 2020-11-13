#!/bin/bash
#
# install_router.sh - install a mikrotik image as boot partition of a Hetzner Cloud machine in rescue mode.
#                     This code is shadowing the original server partition, so be when you apply this to existing machines.
#                     A reboot enables Terraform to continue straight within the same resource block with the next provisioner.
#                     -written by selfscrum. C 2020, MIT-Licence
#     

curl -L https://download.mikrotik.com/routeros/6.46.8/chr-6.46.8.img.zip | funzip | dd of=/dev/sda bs=1M
reboot
