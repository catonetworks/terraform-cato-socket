
resource "cato_socket_site" "site" {
  name            = var.site_name
  description     = var.site_description
  site_type       = var.site_type
  connection_type = var.connection_type

  native_range = {
    native_network_range = var.native_network_range
    local_ip             = var.local_ip
    gateway              = var.native_range_gateway
    vlan                 = var.native_range_vlan
    mdns_reflector       = var.native_range_mdns_reflector
    translated_subnet    = var.native_range_translated_subnet
    interface_dest_type  = var.interface_dest_type
    lag_min_links        = var.lag_min_links
    interface_name       = var.interface_name
    dhcp_settings        = var.native_range_dhcp_settings
  }

  site_location = var.site_location
}

data "cato_accountSnapshotSite" "site" {
  id = cato_socket_site.site.id
}

resource "cato_wan_interface" "wan" {
  for_each             = { for interface in var.cato_interfaces : interface.interface_index => interface }
  depends_on           = [cato_socket_site.site]
  site_id              = cato_socket_site.site.id
  interface_id         = each.value.interface_index
  name                 = each.value.name
  upstream_bandwidth   = each.value.upstream_bandwidth
  downstream_bandwidth = each.value.downstream_bandwidth
  role                 = each.value.role
  precedence           = each.value.precedence
}

# Regular LAN interfaces (excluding LAG_LAN_MEMBER interfaces)
module "lan_interfaces" {
  source            = "./modules/lan_interface"
  for_each          = { for interface in var.lan_interfaces : interface.interface_index => interface if interface.interface_index != null && interface.dest_type != null && interface.dest_type != "LAN_LAG_MEMBER" }
  depends_on        = [cato_socket_site.site]
  site_id           = cato_socket_site.site.id
  connection_type   = var.connection_type
  interface_id      = each.value.interface_index
  local_ip          = each.value.local_ip
  subnet            = each.value.subnet
  translated_subnet = each.value.translated_subnet
  interface_index   = each.value.interface_index
  name              = each.value.name
  network_ranges    = each.value.network_ranges != null ? each.value.network_ranges : []
  dest_type         = each.value.dest_type
  vrrp_type         = try(each.value.vrrp_type, null)
}

# LAG_LAN_MEMBER interfaces (dependent on regular LAN interfaces being created first)
resource "cato_lan_interface_lag_member" "lag_lan_members" {
  depends_on        = [module.lan_interfaces]
  for_each          = { for interface in var.lan_interfaces : interface.interface_index => interface if interface.interface_index != null && interface.dest_type == "LAN_LAG_MEMBER" }
  dest_type         = each.value.dest_type
  interface_id      = each.value.interface_index
  name              = each.value.name
  site_id           = cato_socket_site.site.id
}

# Network ranges for the default/native LAN interface
# These are created directly without a separate LAN interface resource
resource "cato_network_range" "default_interface_ranges" {
  for_each = {
    for idx, range in var.default_interface_network_ranges : 
    "${try(range.interface_index, "DEFAULT")}-${replace(range.name, " ", "_")}-${idx}" => range
  }
  depends_on        = [module.lan_interfaces]
  site_id           = cato_socket_site.site.id
  interface_id      = cato_socket_site.site.native_range.interface_id
  name              = each.value.name
  range_type        = each.value.range_type
  subnet            = each.value.subnet
  local_ip          = try(each.value.local_ip, "") != "" ? each.value.local_ip : null
  gateway           = try(each.value.gateway, "") != "" ? each.value.gateway : null
  vlan              = each.value.vlan
  translated_subnet = each.value.translated_subnet
  internet_only     = try(each.value.internet_only, false)
  mdns_reflector    = try(each.value.mdns_reflector, false)
  
  # DHCP settings - only for VLAN and Native range types
  dhcp_settings = (
    each.value.dhcp_settings != null && 
    (each.value.range_type == "VLAN" || each.value.range_type == "Native")
  ) ? {
    dhcp_type                  = each.value.dhcp_settings.dhcp_type
    ip_range                  = each.value.dhcp_settings.dhcp_type != "DHCP_DISABLED" && each.value.dhcp_settings.ip_range != null && each.value.dhcp_settings.ip_range != "" ? each.value.dhcp_settings.ip_range : null
    relay_group_id            = each.value.dhcp_settings.dhcp_type == "DHCP_RELAY" && each.value.dhcp_settings.relay_group_id != null && each.value.dhcp_settings.relay_group_id != "" ? each.value.dhcp_settings.relay_group_id : null
    relay_group_name          = each.value.dhcp_settings.dhcp_type == "DHCP_RELAY" && each.value.dhcp_settings.relay_group_name != null && each.value.dhcp_settings.relay_group_name != "" ? each.value.dhcp_settings.relay_group_name : null
    dhcp_microsegmentation    = each.value.dhcp_settings.dhcp_microsegmentation
  } : null
}

resource "cato_license" "license" {
  depends_on = [cato_socket_site.site]
  count      = var.license_id == null ? 0 : 1
  site_id    = cato_socket_site.site.id
  license_id = var.license_id
  bw         = var.license_bw == null ? null : var.license_bw
}
