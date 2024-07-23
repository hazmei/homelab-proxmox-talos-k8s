resource "time_sleep" "this" {
  create_duration = "1m"

  depends_on = [
    module.talos_control_nodes,
  ]
}

# TODO
# need a better way to check that the server has booted up and is
# ready to accept connection request to bootstrap before
# running the command
resource "talos_machine_bootstrap" "this" {
  node                 = local.cluster_endpoint_ip
  client_configuration = talos_machine_secrets.machine_secret.client_configuration

  depends_on = [
    time_sleep.this,
  ]
}

resource "talos_machine_secrets" "machine_secret" {
  talos_version = var.talos_version
}

resource "local_sensitive_file" "talosconfig" {
  content  = data.talos_client_configuration.client.talos_config
  filename = "${path.module}/talosconfig"

  depends_on = [
    talos_machine_bootstrap.this,
  ]
}

resource "null_resource" "kubeconfig" {
  provisioner "local-exec" {
    command = "talosctl kubeconfig --force -n ${local.cluster_endpoint_ip} -e ${local.cluster_endpoint_ip} --talosconfig ${path.module}/talosconfig"
  }

  depends_on = [
    local_sensitive_file.talosconfig,
  ]
}

resource "null_resource" "kubeconfigapi" {
  provisioner "local-exec" {
    command = "kubectl --kubeconfig ~/.kube/config config set clusters.${var.name}-cluster.server https://${local.cluster_endpoint_ip}:6443"
  }
  depends_on = [
    null_resource.kubeconfig,
  ]
}

# Note: This doesn't work as well as expected
# TODO: Fix the data resource talos_cluster_health
resource "null_resource" "talos_health" {
  provisioner "local-exec" {
    command = "talosctl health --talosconfig ${path.module}/talosconfig"
  }

  depends_on = [
    null_resource.kubeconfig,
  ]
}