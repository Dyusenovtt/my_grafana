output "monitoring_ip" {
  value = yandex_compute_instance.monitoring.network_interface.0.nat_ip_address
}
