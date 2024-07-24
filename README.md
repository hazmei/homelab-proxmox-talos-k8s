# homelab-proxmox-talos-k8s

This repository contains the terraform code used to spin up kubernetes cluster on [Proxmox VE](https://www.proxmox.com/en/proxmox-virtual-environment/overview) using [Talos Linux](https://www.talos.dev/) OS.

[sparrow-bork/vm-nocloud/proxmox](https://registry.terraform.io/modules/sparrow-bork/vm-nocloud/proxmox/latest) terraform module is used to generate the [Proxmox VE](https://www.proxmox.com/en/proxmox-virtual-environment/overview) VM for each nodes.

### Pre-commit Setup

Install pre-commit and detect-secrets
```bash
brew update
brew install pre-commit detect-secrets
```


### Usage

environment variables
```bash
export PM_API_URL="https://<proxmox-ve-ip>:8006/api2/json"
export PM_API_TOKEN_ID="<user>@<realm>!<token-id>"
export PM_API_TOKEN_SECRET="<api-token-secret>"
```

terraform.tfvars
```terraform
name        = "test"
target_node = "pve"
storage     = "ssd"
vm_state    = "running"

bootable_iso = "ssd:iso/talos-nocloud-amd64.iso"

k8s_controlplane_virtual_ip = "10.255.0.210"

nodes_config = {
  control_plane = {
    count   = 3
    sockets = 1
    cores   = 2
    vcpus   = 2
    memory  = 8192
    storage = "128"
  }
  data_plane = {
    count   = 3
    cores   = 2
    vcpus   = 2
    memory  = 8192
    storage = "128"
  }
  network = {
    ip_subnet  = "10.255.0.0"
    ip_hostnum = 200
    ip_prefix  = 24
    ip_gateway = "10.255.0.254"
  }
}
```
