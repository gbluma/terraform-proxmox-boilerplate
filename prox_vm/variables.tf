
variable "vm_name" {
    type = string
    default = "unnamed-vm"
}

variable "vm_id" {
    type = number
    default = 2101
}

variable "vm_memory" {
    type = number
    default = 512
}

variable "vm_cores" {
    type = number
    default = 1
}

variable "vm_vlan" {
    type = number
    default = 2
}

variable "vm_ip" {
    type = string
    default = "192.168.2.101"
}

variable "pve_node" {
    type = string
    default = "pve"
}

