
# Local to determine if we should create the interface
locals {
  create_interface = var.dest_type != null
  # Pre-calculate interface_id to avoid circular dependency
  calculated_interface_id = local.create_interface ? cato_lan_interface.interface[var.interface_index].id : null
}

resource "cato_lan_interface" "interface" {
  for_each          = local.create_interface ? { (var.interface_index) = true } : {}
  site_id           = var.site_id
  interface_id      = var.interface_index
  name              = var.name == null ? var.interface_index : var.name
  dest_type         = var.dest_type
  local_ip          = var.local_ip
  subnet            = var.subnet
  translated_subnet = var.translated_subnet
  vrrp_type         = var.vrrp_type
}

module "network_ranges" {
  depends_on = [cato_lan_interface.interface]
  #source = "catonetworks/network-ranges-bulk/cato"
  source = "../../../terraform-cato-network-ranges-bulk"
  
  network_range_data = [
    for range in var.network_ranges : merge(range, {
      site_id         = var.site_id
      interface_index = var.interface_index
      # Use the pre-calculated interface_id to avoid circular dependency
      interface_id    = local.calculated_interface_id
    })
  ]
}
