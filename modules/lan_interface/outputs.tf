output "lan_interface" {
  value = cato_lan_interface.interface
}

output "network_ranges" {
  value = { for k, v in module.network_range : k => {
    with_dhcp = v.network_range_with_dhcp
    no_dhcp   = v.network_range_no_dhcp
  } }
}