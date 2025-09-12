
locals {
  # Map LAN interface index based on connection type
  cur_interface_index = (
    var.interface_index == "LAN" ? (
      var.connection_type == "SOCKET_X1600" ? "INT_5" :
      var.connection_type == "SOCKET_X1600_LTE" ? "INT_5" :
      var.connection_type == "SOCKET_X1700" ? "INT_3" :
      "LAN1"
    ) : var.interface_index
  )
}

resource "cato_lan_interface" "interface" {
  for_each          = var.interface_index == "LAN" ? {} : { (local.cur_interface_index) = true }
  site_id           = var.site_id
  interface_id      = local.cur_interface_index
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
      interface_index = local.cur_interface_index
      # Pass the actual interface_id from the created LAN interface
      interface_id    = var.interface_index == "LAN" ? null : values(cato_lan_interface.interface)[0].id
    })
  ]
}
