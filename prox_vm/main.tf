
terraform {
    required_providers {
        proxmox = {
            source = "danitso/proxmox"
            version = "0.4.4"
        }
    }
}

resource "proxmox_virtual_environment_vm" "example" {
  name      = "${var.vm_name}"
  node_name = var.pve_node
  pool_id   = "terraform"
  vm_id     = var.vm_id
  description = "Managed by Terraform"

  lifecycle {
    create_before_destroy = false     # TODO: review if this is what you want.
  }

  clone {
    vm_id = 125  # TODO: this is the source vm, you'll need to point this to a VM template that exists in your environment.
    full = false # don't do a full copy, use linked clone instead
    retries = 3
  }

  cpu { 
    cores = var.vm_cores
    type = "host"
    flags = ["+aes"]
  }

  memory { dedicated = var.vm_memory }

  network_device { 
    vlan_id = var.vm_vlan    # TODO: comment this out if you don't use VLANs

    # use predictable mac addresses based on vm-identifier, so dhcp leases are reusable
    mac_address = "${upper(format("00:00:00:00:%02x:%02x", floor(var.vm_id / 256), var.vm_id % 256))}" 
  }

  vga { type = "virtio" }

  agent { enabled = true }

  initialization {
    user_data_file_id = proxmox_virtual_environment_file.cloud_config.id    # reference to cloud-init config below

    # TODO: Uncomment and edit these settings to configure the VM DNS settings
    #dns {
    #  domain = "192.168.2.17"       # change this to match your own network
    #  server = "192.168.2.1"
    #}

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }
  
}

#===============================================================================
# Cloud Config (cloud-init)
#===============================================================================

resource "proxmox_virtual_environment_file" "cloud_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.pve_node

  source_raw {
    data = <<EOF
#cloud-config
preserve_hostname: false
hostname: ${var.vm_name}
fqdn: ${var.vm_name}.localdomain
package_update: true
package_upgrade: true
packages:
  - qemu-guest-agent
  - python3
# TODO: configure user account information
users:
  - default
  - name: root
    groups: sudo
    shell: /bin/bash
    ssh-authorized-keys:
      - "[redacted]"
    sudo: ALL=(ALL) NOPASSWD:ALL
ssh_pwauth: True   # enables SSH password authentication, set to False if no SSH pw auth is desired.
# TODO: make sure to edit your passwords 
chpasswd:
  list: |
    root:mypassword
  expire: false

network:
  version: 2
  ethernets:
    eth0:
      dhcp6: false
      dhcp4: true
write_files:
  - content: |
      hello world
    path: /tmp/hello
EOF
    file_name = "terraform-provider-proxmox-${var.vm_name}-cloud-config.yaml"
  }
}

