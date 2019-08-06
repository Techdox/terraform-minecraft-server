output "serverip" {
  value = "${google_compute_address.static-ip-address.address}"
}

output "servername" {
  value = "${google_compute_instance.default.name}"
}
