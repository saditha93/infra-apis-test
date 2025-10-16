output "server_ip" { value = hcloud_server.vm.ipv4_address }
output "api1_host" { value = var.api1_host }
output "api2_host" { value = var.api2_host }