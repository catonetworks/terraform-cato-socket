# CATO SOCKET Terraform module

Terraform module which creates a Socket Site in the Cato Management Application (CMA), and supports bulk configuring socket interfaces and network ranges. 

## Usage

```hcl
terraform {
  required_providers {
    cato = {
      source = "catonetworks/cato"
    }
  }
  required_version = ">= 1.3.0"
}


provider "cato" {
  baseurl    = var.baseurl
  token      = var.token
  account_id = var.cato_account_id
}

variable "baseurl" {
  default = ""
}

variable "token" {
  default = ""
}

variable "cato_account_id" {
  default = ""
}

data "cato_siteLocation" "ny" {
  filters = [{
    field     = "city"
    search    = "New York City"
    operation = "exact"
    },
    {
      field     = "state_name"
      search    = "New York"
      operation = "exact"
    },
    {
      field     = "country_name"
      search    = "United"
      operation = "contains"
  }]
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
    city         = data.cato_siteLocation.ny.locations[0].city
    country_code = data.cato_siteLocation.ny.locations[0].country_code
    state_code   = data.cato_siteLocation.ny.locations[0].state_code
    timezone     = data.cato_siteLocation.ny.locations[0].timezone[0]
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
| [cato_socket_site.site](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/resources/socket_site) | resource |
| [cato_wan_interface.wan](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/resources/wan_interface) | resource |
| [cato_accountSnapshotSite.site](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/data-sources/accountSnapshotSite) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cato_interfaces"></a> [cato\_interfaces](#input\_cato\_interfaces) | n/a | <pre>list(object({<br/>    interface_id         = string<br/>    name                 = string<br/>    upstream_bandwidth   = number<br/>    downstream_bandwidth = number<br/>    role                 = string<br/>    precedence           = string<br/>  }))</pre> | `[]` | no |
| <a name="input_connection_type"></a> [connection\_type](#input\_connection\_type) | Connection type can be SOCKET\_AWS1500, SOCKET\_AZ1500, SOCKET\_ESX1500, SOCKET\_X1500, SOCKET\_X1600, SOCKET\_X1600\_LTE, SOCKET\_X1700 | `string` | `null` | no |
| <a name="input_lan_interfaces"></a> [lan\_interfaces](#input\_lan\_interfaces) | n/a | <pre>list(object({<br/>    interface_id      = string<br/>    name              = string<br/>    dest_type         = string<br/>    local_ip          = string<br/>    subnet            = string<br/>    translated_subnet = string<br/>    network_ranges = list(object({<br/>      name              = string<br/>      range_type        = string<br/>      subnet            = string<br/>      local_ip          = string<br/>      gateway           = string<br/>      vlan              = number<br/>      translated_subnet = string<br/>      dhcp_settings = object({<br/>        dhcp_type = string<br/>        ip_range  = string<br/>      })<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_local_ip"></a> [local\_ip](#input\_local\_ip) | Native network range | `string` | `null` | no |
| <a name="input_native_network_range"></a> [native\_network\_range](#input\_native\_network\_range) | Native network range | `string` | `null` | no |
| <a name="input_site_description"></a> [site\_description](#input\_site\_description) | n/a | `string` | `null` | no |
| <a name="input_site_location"></a> [site\_location](#input\_site\_location) | n/a | <pre>object({<br/>    city         = string<br/>    country_code = string<br/>    state_code   = string<br/>    timezone     = string<br/>  })</pre> | n/a | yes |
| <a name="input_site_name"></a> [site\_name](#input\_site\_name) | n/a | `string` | `null` | no |
| <a name="input_site_type"></a> [site\_type](#input\_site\_type) | Site type can be BRANCH, CLOUD\_DC, DATACENTER, HEADQUARTERS | `string` | `"BRANCH"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_site_id"></a> [site\_id](#output\_site\_id) | ID of the created socket site |
| <a name="output_site_location"></a> [site\_location](#output\_site\_location) | Location of the socket site |
| <a name="output_site_name"></a> [site\_name](#output\_site\_name) | Name of the socket site |
<!-- END_TF_DOCS -->