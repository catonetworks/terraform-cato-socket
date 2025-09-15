
resource "cato_lan_interface" "interface" {
  for_each          = var.dest_type == null ? {} : { (var.interface_index) = true }
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
  depends_on = [ cato_lan_interface.interface ]
  source = "catonetworks/network-ranges-bulk/cato"
  network_range_data = [
    for range in var.network_ranges : merge(range, {
      site_id         = var.site_id
      interface_index = var.interface_index
      # Pass the actual interface_id from the created LAN interface if it exists, otherwise null
      interface_id    = var.dest_type == null ? null : values(cato_lan_interface.interface)[0].id
    })
  ]
}
