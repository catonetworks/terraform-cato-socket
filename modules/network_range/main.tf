
resource "cato_network_range" "with_dhcp" {
  ## If dhcp_settings is null then don't build (count = 0, else count=1)
  count        = var.dhcp_settings == null ? 0 : 1
  site_id      = var.site_id
  interface_id = var.interface_id
  name         = var.name
  range_type   = var.range_type
  subnet       = var.subnet
  local_ip     = var.local_ip
  gateway      = var.gateway
  vlan         = var.vlan
  dhcp_settings = {
    dhcp_type = var.dhcp_settings.dhcp_type
    ip_range  = var.dhcp_settings.ip_range
  }
}

resource "cato_network_range" "no_dhcp" {
  ## If dhcp_settings is null then build (count = 1, else count=0)
  count        = var.dhcp_settings == null ? 1 : 0
  site_id      = var.site_id
  interface_id = var.interface_id
  name         = var.name
  range_type   = var.range_type
  subnet       = var.subnet
  local_ip     = var.local_ip
  gateway      = var.gateway
  vlan         = var.vlan
}