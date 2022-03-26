
# this file describes the deployments, 

module "prox-web-prod" {
    # use custom defaults to build from
    source = "./prox_vm"

    # number of instances to build (working)
    count = 1

    # tell proxmox which host to build on
    pve_node = "pve"

    # VM configuration
    vm_id = 2081 + count.index   # high number to avoid conflicts
    vm_name = "ec2-nginx-prod-${format("%02d", count.index)}"
    vm_memory = 600
    vm_cores = 1
    vm_vlan = 2
}
