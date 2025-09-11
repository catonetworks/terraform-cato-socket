output "lan_interface" {
  value = cato_lan_interface.interface
}

output "network_ranges" {
  value = {
    network_ranges = module.network_ranges
  }
}
