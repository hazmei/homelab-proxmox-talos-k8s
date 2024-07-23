resource "local_file" "cloud_init_user_data_control_file" {
  content  = data.talos_machine_configuration.control.machine_configuration
  filename = "${path.module}/files/user_data_${var.name}_control.cfg"
}

resource "local_file" "cloud_init_user_data_data_file" {
  content  = data.talos_machine_configuration.data.machine_configuration
  filename = "${path.module}/files/user_data_${var.name}data.cfg"
}