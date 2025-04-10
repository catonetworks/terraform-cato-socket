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