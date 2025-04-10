# CATO SOCKET Terraform module

Terraform module which creates a Socket Site in the Cato Management Application (CMA), and supports bulk configuring socket interfaces and network ranges. 

## Usage

```hcl
data "cato_siteLocation" "ny" {
  filters = [{
    field = "city"
    search = "New York City"
    operation = "exact"
  },
  {
    field = "state_name"
    search = "New York"
    operation = "exact"
  },
 {
    field = "country_name"
    search = "United"
    operation = "contains"
  }]
}

module "socket-site" {
  providers = {
    cato = cato
  }
  source               = "catonetworks/socket/cato"
  site_name            = "Cato-X1600"
  site_description     = "Cato-X1600"
  native_network_range = "10.11.3.0/24"
  local_ip             = "10.11.3.5"
  site_type            = "BRANCH"
  connection_type      = "SOCKET_X1600"
  site_location = {
    city = data.cato_siteLocation.ny.locations[0].city
    country_code = data.cato_siteLocation.ny.locations[0].country_code
    state_code = data.cato_siteLocation.ny.locations[0].state_code
    timezone = data.cato_siteLocation.ny.locations[0].timezone
  }
  cato_interfaces = [
    {
      interface_id         = "INT_4"
      name                 = "Interface wan 4"
      upstream_bandwidth   = 100
      downstream_bandwidth = 100
      role                 = "wan_2"
      precedence           = "ACTIVE"
    }
  ]
  lan_interfaces = [
    {
      name              = "Interface lan 6"
      interface_id      = "INT_6"
      dest_type         = "LAN"
      subnet            = "192.168.198.0/25"
      local_ip          = "192.168.198.6"
      translated_subnet = null
      network_ranges = [
        {
          name              = "Routed_Range"
          range_type        = "VLAN"
          subnet            = "192.168.199.0/25"
          local_ip          = "192.168.199.6"
          gateway           = null
          vlan              = 10
          translated_subnet = null
          dhcp_settings = null
        }
      ]
    },
    {
      name              = "Interface lan 7"
      interface_id      = "INT_7"
      dest_type         = "LAN"
      subnet            = "192.168.187.0/25"
      local_ip          = "192.168.187.6"
      translated_subnet = null
      network_ranges = [
        {
          name              = "VLAN_TF2"
          range_type        = "VLAN"
          subnet            = "192.168.188.0/25"
          local_ip          = "192.168.188.6"
          gateway           = null
          vlan              = 11
          translated_subnet = null
          dhcp_settings = null
        },
        {
          name              = "VLAN_TF3"
          range_type        = "VLAN"
          subnet            = "192.168.189.0/25"
          local_ip          = "192.168.189.6"
          gateway           = null
          vlan              = 12
          translated_subnet = null
          dhcp_settings = null
        },
        {
          name              = "RoutedFW"
          range_type        = "Routed"
          subnet            = "172.22.123.0/25"
          local_ip          = null
          gateway           = "192.168.188.7"
          vlan              = null
          translated_subnet = null
          dhcp_settings = null
        }
      ]
    }
  ]
}
```

## Site Location Reference

For more information on site_location syntax, use the [Cato CLI](https://github.com/catonetworks/cato-cli) to lookup values.

```bash
$ pip3 install catocli
$ export CATO_TOKEN="your-api-token-here"
$ export CATO_ACCOUNT_ID="your-account-id"
$ catocli query siteLocation -h
$ catocli query siteLocation '{"filters":[{"search": "San Diego","field":"city","operation":"exact"}]}' -p
```

## Authors

Module is maintained by [Cato Networks](https://github.com/catonetworks) with help from [these awesome contributors](https://github.com/catonetworks/terraform-cato-socket/graphs/contributors).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/catonetworks/terraform-cato-socket/tree/master/LICENSE) for full details.

