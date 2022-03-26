
# Terraform boilerplate for Proxmox

Quick note: search for the string "TODO" to find where you need to customize things.

This just describes one method I used to get Terrform working with Proxmox.
It may not be the ideal way, and my configuration bakes-in a lot of assumptions that might not apply for you.

These assumptions are:

## 1. VMs are cloned from a template using lvm-thin

This allows for fast creation and deletion, with minimal disk usage per VM.

A consequence of this choice is that all VMs cloned from this source will need to exist on the same storage pool, AFAIK.
Likely there are also problems with migrating from one host to another.
But, my system is a development environment, so fast iteration is more valuable than robust deployments.

LVM thin pools aren't the default choice for storage in Proxmox, so for information setup, check the [documentation](https://pve.proxmox.com/wiki/Storage:_LVM_Thin).

## 2. I use VLANs in my homelab

Each logical group of VMs get their own VLAN ID so that managing network rules makes sense.
This is a feature that you might not have in your router, so if it's a problem, my recommendation is to set VLAN to "" (blank).

## 3. MAC addresses should be repeatable

I use dhcp leases (60 days) for most of my systems, the benefit is that things will auto-cleanup if not used but live long enough to survive temporary downtime.
The configuration that makes this work is by turning the VMID into the trailing part of the MAC address.
If this is something you don't want/need, just remove the MAC address assignment and let proxmox randomize a MAC address.

## 4. I'm using CloudInit for initial configuration

[CloudInit](https://cloud-init.io/) is a fancy tool that can specify how the system should be configured on first boot.
Distros like Ubuntu, Fedora, and OpenSUSE have support for it.
In my configs, I've built in this as part of the setup process so that package installs, user setup, and SSH keys are ready when the system comes online.

# Usage

* Clone this repo
* Edit files (most areas are tagged with the word "TODO")
* `terraform init` pulls in the danitso repo
* `terraform plan` verifies that communication is working, etc.
* `terraform apply` actually tries to make changes.

# Disclaimers

* I am not using this in production, so don't assume this is a battle-tested configuration.
* I am not a Terraform or Proxmox expert, just a guy trying to learn stuff in my homelab.
* No warranty, etc. Some changes cause a rebuild of a VM, so make sure you can absorb any damage a change may cause.

# License

BSD. Use it for whatever you want, no attribution needed. 
