resource "cato_lan_interface" "interface" {
  site_id           = var.site_id
  interface_id      = var.interface_id
  name              = var.name
  dest_type         = var.dest_type
  local_ip          = var.local_ip
  subnet            = var.subnet
  translated_subnet = var.translated_subnet
  vrrp_type         = var.vrrp_type
}  

module "network_range" {
  depends_on = [cato_lan_interface.interface]
  providers = {
    cato = cato
  }
  source                 = "../network_range"
  for_each               = { for network_range in var.network_ranges : network_range.subnet => network_range }
  site_id                = var.site_id
  interface_id           = cato_lan_interface.interface.id
  name                   = each.value.name
  range_type             = each.value.range_type
  subnet                 = each.value.subnet
  local_ip               = each.value.local_ip
  gateway                = each.value.gateway
  vlan                   = each.value.vlan
  dhcp_settings          = each.value.dhcp_settings
}
