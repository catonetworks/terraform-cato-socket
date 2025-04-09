output "network_interface_id" {
  description = "ID of the matched network interface"
  value       = data.cato_networkInterfaces.interface.items[0].id
}

output "network_range_id" {
  description = "ID of the created network range"
  value = try(cato_network_range.no_dhcp[0].id, cato_network_range.with_dhcp[0].id)
}

output "network_range_name" {
  description = "Name of the created network range"
  value = try(cato_network_range.no_dhcp[0].name, cato_network_range.with_dhcp[0].name)
}

output "network_range_subnet" {
  description = "Subnet of the created network range"
  value = try(cato_network_range.no_dhcp[0].subnet, cato_network_range.with_dhcp[0].subnet)
}