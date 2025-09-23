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
  value = merge(
    { for k, v in module.lan_interfaces : k => {
      interface      = v.lan_interface
      network_ranges = v.network_ranges
    } },
    { for k, v in cato_lan_interface_lag_member.lag_lan_members : k => {
      interface      = v
      network_ranges = []  # LAG member interfaces don't have network ranges directly
    } }
  )
}

output "default_interface_network_ranges" {
  description = "Network ranges created for the default/native LAN interface"
  value = { for k, v in cato_network_range.default_interface_ranges : k => v }
}

output "cato_license_site" {
  value = var.license_id == null ? null : {
    id           = cato_license.license[0].id
    license_id   = cato_license.license[0].license_id
    license_info = cato_license.license[0].license_info
    site_id      = cato_license.license[0].site_id
  }
}
