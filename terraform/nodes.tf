module "talos_control_nodes" {
  source  = "sparrow-bork/vm-nocloud/proxmox"
  version = "~> 0.0.4"

  name          = "${var.name}-control"
  vm_count      = var.nodes_config.control_plane.count
  target_node   = var.target_node
  storage_name  = var.storage
  user_data     = data.talos_machine_configuration.control.machine_configuration
  vm_onboot     = var.vm_onboot
  vm_state      = var.vm_state
  vm_protection = var.vm_protection
  bootable_iso  = var.bootable_iso

  resource_allocation = {
    sockets = var.nodes_config.control_plane.sockets
    cores   = var.nodes_config.control_plane.cores
    vcpus   = var.nodes_config.control_plane.vcpus
    memory  = var.nodes_config.control_plane.memory
    storage = var.nodes_config.control_plane.storage
  }

  network = var.nodes_config.network
}

module "talos_data_nodes" {
  source  = "sparrow-bork/vm-nocloud/proxmox"
  version = "~> 0.0.4"

  name          = "${var.name}-data"
  vm_count      = var.nodes_config.data_plane.count
  target_node   = var.target_node
  skip_vm_id    = 20
  storage_name  = var.storage
  user_data     = data.talos_machine_configuration.data.machine_configuration
  vm_onboot     = var.vm_onboot
  vm_state      = var.vm_state
  vm_protection = var.vm_protection
  bootable_iso  = var.bootable_iso

  resource_allocation = {
    sockets = var.nodes_config.control_plane.sockets
    cores   = var.nodes_config.control_plane.cores
    vcpus   = var.nodes_config.data_plane.vcpus
    memory  = var.nodes_config.data_plane.memory
    storage = var.nodes_config.data_plane.storage
  }

  network = var.nodes_config.network
}
