
terraform {
    required_providers {
        proxmox = {
            source = "danitso/proxmox"
            version = "0.4.4"
        }
    }
}

# configure provider to have access to proxmox admin features
provider "proxmox" {
    virtual_environment {
        # TODO: edit url and security settings to match your environment
        insecure = true    # self-signed cert
        endpoint = "https://192.168.1.3:8006"      # same as web gui URL

        # TODO: edit user/password details to match your environment
        username = "root@pam"       # user with access
        password = "blahblahblah"   # replace with your own proxmox password
    }
}


