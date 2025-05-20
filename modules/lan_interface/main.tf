resource "cato_lan_interface" "interface" {
  count             = var.interface_id == "LAN" || var.interface_id == "LAN1" ? 0 : 1
  site_id           = var.site_id
  interface_id      = var.interface_id
  name              = var.name == null ? var.interface_id : var.name
  dest_type         = var.dest_type
  local_ip          = var.local_ip
  subnet            = var.subnet
  translated_subnet = var.translated_subnet
  vrrp_type         = var.vrrp_type
}

data "cato_networkInterfaces" "interface" {
  count                   = var.interface_id == "LAN" || var.interface_id == "LAN1" ? 1 : 0
  site_id                 = var.site_id
  network_interface_index = var.interface_id
}

locals {
  interface_id = var.interface_id == "LAN" || var.interface_id == "LAN1" ? data.cato_networkInterfaces.interface[0].items[0].id : cato_lan_interface.interface[0].id
}

module "network_range" {
  depends_on    = [cato_lan_interface.interface]
  source        = "../network_range"
  for_each      = { for network_range in var.network_ranges : network_range.subnet => network_range }
  site_id       = var.site_id
  interface_id  = local.interface_id
  name          = each.value.name
  range_type    = each.value.range_type
  subnet        = each.value.subnet
  local_ip      = each.value.local_ip
  gateway       = each.value.gateway
  vlan          = each.value.vlan
  dhcp_settings = each.value.dhcp_settings
}
