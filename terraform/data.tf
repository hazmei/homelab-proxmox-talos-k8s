# https://github.com/kubebn/talos-proxmox-kaas/blob/main/terraform/talos.tf
data "talos_machine_configuration" "control" {
  cluster_name       = "${var.name}-cluster"
  machine_type       = "controlplane"
  cluster_endpoint   = "https://${local.cluster_endpoint_ip}:6443"
  machine_secrets    = talos_machine_secrets.machine_secret.machine_secrets
  kubernetes_version = var.k8s_version
  talos_version      = var.talos_version
  docs               = false
  examples           = false
  config_patches = [
    templatefile("${path.module}/files/controlplane.yaml",
      {
        virtual_ip = var.k8s_controlplane_virtual_ip
      }
    )
  ]
}

data "talos_machine_configuration" "data" {
  cluster_name       = "${var.name}-cluster"
  machine_type       = "worker"
  cluster_endpoint   = "https://${local.cluster_endpoint_ip}:6443"
  machine_secrets    = talos_machine_secrets.machine_secret.machine_secrets
  kubernetes_version = var.k8s_version
  talos_version      = var.talos_version
  docs               = false
  examples           = false
  config_patches = [
    templatefile("${path.module}/files/dataplane.yaml",
      {
        virtual_ip = var.k8s_controlplane_virtual_ip
      }
    )
  ]
}

data "talos_client_configuration" "client" {
  cluster_name         = "${var.name}-cluster"
  client_configuration = talos_machine_secrets.machine_secret.client_configuration
  nodes                = [local.cluster_endpoint_ip]
  endpoints            = [local.cluster_endpoint_ip]
}

# # This is not working
# # https://github.com/siderolabs/terraform-provider-talos/issues/153
# # │ Error: health check messages:
# # │ discovered nodes: ["10.255.0.200"]
# # │ waiting for etcd to be healthy: ...
# # │ waiting for etcd to be healthy: OK
# # │ waiting for etcd members to be consistent across nodes: ...
# # │ waiting for etcd members to be consistent across nodes: OK
# # │ waiting for etcd members to be control plane nodes: ...
# # │ waiting for etcd members to be control plane nodes: etcd member ips ["10.255.0.202" "10.255.0.201" "10.255.0.200"] are not subset of control plane node ips ["10.255.0.200"]
# data "talos_cluster_health" "this" {
#   client_configuration = talos_machine_secrets.machine_secret.client_configuration

#   control_plane_nodes = [
#     "10.255.0.200"
#     # local.cluster_endpoint_ip,
#   ]

#   endpoints = data.talos_client_configuration.client.endpoints

#   timeouts = {
#     read = "30s"
#   }

#   depends_on = [
#     talos_machine_bootstrap.this,
#   ]
# }