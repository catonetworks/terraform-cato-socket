
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
    dhcp_settings        = var.native_range_dhcp_settings
  }

  site_location = var.site_location
}

data "cato_accountSnapshotSite" "site" {
  id = cato_socket_site.site.id
}

resource "cato_wan_interface" "wan" {
  for_each             = { for interface in var.cato_interfaces : interface.interface_index => interface }
  site_id              = cato_socket_site.site.id
  interface_id         = each.value.interface_index
  name                 = each.value.name
  upstream_bandwidth   = each.value.upstream_bandwidth
  downstream_bandwidth = each.value.downstream_bandwidth
  role                 = each.value.role
  precedence           = each.value.precedence
}

module "lan_interfaces" {
  source            = "./modules/lan_interface"
  for_each          = { for interface in var.lan_interfaces : interface.interface_index => interface if interface.interface_index != null }
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

resource "cato_license" "license" {
  depends_on = [cato_socket_site.site]
  count      = var.license_id == null ? 0 : 1
  site_id    = cato_socket_site.site.id
  license_id = var.license_id
  bw         = var.license_bw == null ? null : var.license_bw
}
