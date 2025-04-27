output "site_id" {
  description = "ID of the created socket site"
  value       = cato_socket_site.site.id
}

output "site_name" {
  description = "Name of the socket site"
  value       = cato_socket_site.site.name
}

output "site_location" {
  description = "Location of the socket site"
  value       = cato_socket_site.site.site_location
}


output "site" {
  value = cato_socket_site.site
}

output "wan_interfaces" {
  value = { for k, v in cato_wan_interface.wan : k => v }
}

output "lan_interfaces" {
  value = { for k, v in module.lan_interfaces : k => {
    interface      = v.lan_interface
    network_ranges = v.network_ranges
  }}
}