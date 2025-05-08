# CATO SOCKET Terraform module

Terraform module which creates a Socket Site in the Cato Management Application (CMA), and supports bulk configuring socket interfaces and network ranges. 

## NOTE
- For help with finding exact sytax to match site location for city, state_name, country_name and timezone, please refer to the [cato_siteLocation data source](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/data-sources/siteLocation).
- For help with finding a license id to assign, please refer to the [cato_licensingInfo data source](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/data-sources/licensingInfo).

## Usage

```hcl
provider "cato" {
  baseurl    = var.baseurl
  token      = var.token
  account_id = var.cato_account_id
}

module "socket-site" {
  source               = "../terraform-cato-socket"
  site_name            = "Cato-X1600"
  site_description     = "Cato-X1600"
  native_network_range = "10.11.3.0/24"
  local_ip             = "10.11.3.5"
  site_type            = "BRANCH"
  connection_type      = "SOCKET_X1600"
  site_location = {
    city         = "New York City"
    country_code = "US"
    state_code   = "US-NY" ## Optional - for countries with states"
    timezone     = "America/New_York"
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
          dhcp_settings     = null
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
          dhcp_settings     = {
            dhcp_type = "DHCP_RANGE"
            ip_range = "192.168.188.10 - 192.168.188.100"
          }
        },
        {
          name              = "VLAN_TF3"
          range_type        = "VLAN"
          subnet            = "192.168.189.0/25"
          local_ip          = "192.168.189.6"
          gateway           = null
          vlan              = 12
          translated_subnet = null
          dhcp_settings     = null
        },
        {
          name              = "RoutedFW"
          range_type        = "Routed"
          subnet            = "172.22.123.0/25"
          local_ip          = null
          gateway           = "192.168.187.7"
          vlan              = null
          translated_subnet = null
          dhcp_settings     = null
        }
      ]
    }
  ]
}

output "Socket_Site_Information" { 
    value = module.socket-site.site
}

output "Socket_WAN_Interface_Information" { 
    value = module.socket-site.wan_interfaces
}

output "Socket_Network_Range_Information" {
  value = flatten([
    for iface_key, iface_value in module.socket-site.lan_interfaces : [
      for subnet, net_info in iface_value.network_ranges : [
        for net_type in ["with_dhcp", "no_dhcp"] : [
          for range in net_info[net_type] : {
            interface_id     = iface_value.interface.interface_id
            interface_name   = iface_value.interface.name
            subnet           = range.subnet
            local_ip         = range.local_ip
            gateway          = range.gateway
            vlan             = range.vlan
            network_range_id = range.id
            dhcp_enabled     = net_type == "with_dhcp"
            dhcp_settings    = range.dhcp_settings
            range_type       = range.range_type
          }
        ]
      ]
    ]
  ])
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


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_cato"></a> [cato](#provider\_cato) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lan_interfaces"></a> [lan\_interfaces](#module\_lan\_interfaces) | ./modules/lan_interface | n/a |

## Resources

| Name | Type |
|------|------|
| [cato_license.license](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/resources/license) | resource |
| [cato_socket_site.site](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/resources/socket_site) | resource |
| [cato_wan_interface.wan](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/resources/wan_interface) | resource |
| [cato_accountSnapshotSite.site](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/data-sources/accountSnapshotSite) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cato_interfaces"></a> [cato\_interfaces](#input\_cato\_interfaces) | n/a | <pre>list(object({<br/>    interface_id         = string<br/>    name                 = string<br/>    upstream_bandwidth   = number<br/>    downstream_bandwidth = number<br/>    role                 = string<br/>    precedence           = string<br/>  }))</pre> | `[]` | no |
| <a name="input_connection_type"></a> [connection\_type](#input\_connection\_type) | Connection type can be SOCKET\_AWS1500, SOCKET\_AZ1500, SOCKET\_ESX1500, SOCKET\_X1500, SOCKET\_X1600, SOCKET\_X1600\_LTE, SOCKET\_X1700 | `string` | `null` | no |
| <a name="input_lan_interfaces"></a> [lan\_interfaces](#input\_lan\_interfaces) | n/a | <pre>list(object({<br/>    interface_id      = string<br/>    name              = string<br/>    dest_type         = string<br/>    local_ip          = string<br/>    subnet            = string<br/>    translated_subnet = string<br/>    network_ranges = list(object({<br/>      name              = string<br/>      range_type        = string<br/>      subnet            = string<br/>      local_ip          = string<br/>      gateway           = string<br/>      vlan              = number<br/>      translated_subnet = string<br/>      dhcp_settings = object({<br/>        dhcp_type = string<br/>        ip_range  = string<br/>      })<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_license_bw"></a> [license\_bw](#input\_license\_bw) | The license bandwidth number for the cato site, specifying bandwidth ONLY applies for pooled licenses.  For a standard site license that is not pooled, leave this value null. Must be a number greater than 0 and an increment of 10. | `string` | `null` | no |
| <a name="input_license_id"></a> [license\_id](#input\_license\_id) | The license ID for the Cato vSocket of license type CATO\_SITE, CATO\_SSE\_SITE, CATO\_PB, CATO\_PB\_SSE.  Example License ID value: 'abcde123-abcd-1234-abcd-abcde1234567'.  Note that licenses are for commercial accounts, and not supported for trial accounts. | `string` | `null` | no |
| <a name="input_local_ip"></a> [local\_ip](#input\_local\_ip) | Native network range | `string` | `null` | no |
| <a name="input_native_network_range"></a> [native\_network\_range](#input\_native\_network\_range) | Native network range | `string` | `null` | no |
| <a name="input_site_description"></a> [site\_description](#input\_site\_description) | n/a | `string` | `null` | no |
| <a name="input_site_location"></a> [site\_location](#input\_site\_location) | n/a | <pre>object({<br/>    city         = string<br/>    country_code = string<br/>    state_code   = string<br/>    timezone     = string<br/>  })</pre> | n/a | yes |
| <a name="input_site_name"></a> [site\_name](#input\_site\_name) | n/a | `string` | `null` | no |
| <a name="input_site_type"></a> [site\_type](#input\_site\_type) | Site type can be BRANCH, CLOUD\_DC, DATACENTER, HEADQUARTERS | `string` | `"BRANCH"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cato_license_site"></a> [cato\_license\_site](#output\_cato\_license\_site) | n/a |
| <a name="output_lan_interfaces"></a> [lan\_interfaces](#output\_lan\_interfaces) | n/a |
| <a name="output_site"></a> [site](#output\_site) | n/a |
| <a name="output_site_id"></a> [site\_id](#output\_site\_id) | ID of the created socket site |
| <a name="output_site_location"></a> [site\_location](#output\_site\_location) | Location of the socket site |
| <a name="output_site_name"></a> [site\_name](#output\_site\_name) | Name of the socket site |
| <a name="output_wan_interfaces"></a> [wan\_interfaces](#output\_wan\_interfaces) | n/a |
<!-- END_TF_DOCS -->