output "network_interface_id" {
  description = "ID of the network interface"
  value       = cato_lan_interface.interface.id
}

output "lan_interface_name" {
  description = "Name of the LAN interface"
  value       = cato_lan_interface.interface.name
}

output "lan_interface_local_ip" {
  description = "Local IP address assigned to the LAN interface"
  value       = cato_lan_interface.interface.local_ip
}

output "lan_interface_subnet" {
  description = "Subnet of the LAN interface"
  value       = cato_lan_interface.interface.subnet
}

output "lan_interface_translated_subnet" {
  description = "Translated subnet for the LAN interface"
  value       = cato_lan_interface.interface.translated_subnet
}

output "lan_interface_vrrp_type" {
  description = "VRRP type of the LAN interface"
  value       = cato_lan_interface.interface.vrrp_type
}