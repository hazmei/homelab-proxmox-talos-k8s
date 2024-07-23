variable "name" {
  description = "The suffix to use for the cloud-init and VM"
  type        = string
}

variable "bootable_iso" {
  description = "The ISO to boot from"
  type        = string
}

variable "target_node" {
  description = "The target node to deploy to"
  type        = string
  default     = "pve"
}

variable "storage" {
  description = "The storage to deploy to"
  type        = string
  default     = "ssd" # or local-lvm

  validation {
    condition     = contains(["local-lvm", "ssd"], var.storage)
    error_message = "Valid values for var: storage are (local-lvm, ssd)."
  }
}

variable "k8s_version" {
  description = "The version of kubernetes to use"
  type        = string
  default     = "v1.30.2"
}

variable "talos_version" {
  description = "The version of talos to use"
  type        = string
  default     = "v1.7.5"
}

variable "vm_onboot" {
  description = "Whether to have the VM startup after PVE node starts"
  type        = bool
  default     = false
}

variable "vm_state" {
  description = "The state of the VM"
  type        = string
  default     = "running"

  validation {
    condition     = contains(["running", "stopped", "started"], var.vm_state)
    error_message = "Valid values for var: vm_state are (running, stopped, started)."
  }
}

variable "vm_protection" {
  description = "Enable/disable the VM protection from being removed"
  type        = bool
  default     = false
}

variable "k8s_controlplane_virtual_ip" {
  description = "Unused IP address for assigning k8s controlplane virtual ip"
  type        = string
  default     = "10.255.0.210"
}

variable "nodes_config" {
  description = "Config for nodes"
  type = object({
    control_plane = object({
      count   = optional(number, 1)
      sockets = optional(number, 1)
      cores   = optional(number, 2)
      vcpus   = optional(number, 2)
      memory  = optional(number, 2048)
      storage = optional(string, "128")
    })
    data_plane = object({
      count   = optional(number, 1)
      sockets = optional(number, 1)
      cores   = optional(number, 2)
      vcpus   = optional(number, 2)
      memory  = optional(number, 2048)
      storage = optional(string, "128")
    })
    network = object({
      ip_subnet  = optional(string, "10.255.0.0")
      ip_hostnum = optional(number, 200)
      ip_prefix  = optional(number, 24)
      ip_gateway = optional(string, "10.255.0.254")
    })
  })
  default = {
    control_plane = {
      count   = 1
      vcpus   = 2
      memory  = 2048
      storage = "128"
    }
    data_plane = {
      count   = 1
      vcpus   = 2
      memory  = 2048
      storage = "128"
    }
    network = {
      ip_subnet  = "10.255.0.0"
      ip_hostnum = 200
      ip_prefix  = 24
      ip_gateway = "10.255.0.254"
    }
  }
}