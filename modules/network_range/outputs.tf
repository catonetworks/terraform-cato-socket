output "network_range_with_dhcp" {
  value = cato_network_range.with_dhcp[*]
}

output "network_range_no_dhcp" {
  value = cato_network_range.no_dhcp[*]
}