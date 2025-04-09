output "site_id" {
  description = "ID of the created socket site"
  value       = cato_socket_site.x1600_site.id
}

output "site_name" {
  description = "Name of the socket site"
  value       = cato_socket_site.x1600_site.name
}

output "site_location" {
  description = "Location of the socket site"
  value       = cato_socket_site.x1600_site.site_location
}

output "snapshot_site_id" {
  description = "ID from the account snapshot site (should match socket site)"
  value       = data.cato_accountSnapshotSite.site.id
}

output "snapshot_site_name" {
  description = "Name from the snapshot of the site"
  value       = data.cato_accountSnapshotSite.site.name
}