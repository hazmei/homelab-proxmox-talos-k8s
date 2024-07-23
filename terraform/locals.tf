locals {
  cluster_endpoint_ip = cidrhost("${var.nodes_config.network.ip_subnet}/${var.nodes_config.network.ip_prefix}", var.nodes_config.network.ip_hostnum)
}