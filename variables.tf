variable "site_name" {
  type    = string
  default = null
}

variable "site_description" {
  type    = string
  default = null
}

variable "native_network_range" {
  description = "Native network range"
  type        = string
  default     = null
}

variable "local_ip" {
  description = "Native network range"
  type        = string
  default     = null
}

variable "site_location" {
  type = object({
    city         = string
    country_code = string
    state_code   = string
    timezone     = string
  })
}

variable "site_type" {
  description = "Site type can be BRANCH, CLOUD_DC, DATACENTER, HEADQUARTERS"
  type        = string
  default     = "BRANCH"
}

variable "connection_type" {
  description = "Connection type can be SOCKET_AWS1500, SOCKET_AZ1500, SOCKET_ESX1500, SOCKET_X1500, SOCKET_X1600, SOCKET_X1600_LTE, SOCKET_X1700"
  type        = string
  default     = null
}

variable "cato_interfaces" {
  type = list(object({
    interface_id         = string
    name                 = string
    upstream_bandwidth   = number
    downstream_bandwidth = number
    role                 = string
    precedence           = string
  }))
  default = []
}

variable "lan_interfaces" {
  type = list(object({
    interface_id      = string
    name              = string
    dest_type         = string
    local_ip          = string
    subnet            = string
    translated_subnet = string
    network_ranges = list(object({
      name       = string
      range_type = string
      subnet     = string
      local_ip   = string
      gateway    = string
      vlan       = number
      translated_subnet = string
      dhcp_settings = object({
        dhcp_type = string
        ip_range  = string
      })
    }))
  }))
  default = []
}
