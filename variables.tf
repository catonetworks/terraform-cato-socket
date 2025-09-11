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
  description = "Native network range local IP"
  type        = string
  default     = null
}

variable "native_range_gateway" {
  description = "Native range gateway"
  type        = string
  default     = null
}

variable "native_range_vlan" {
  description = "Native range VLAN"
  type        = number
  default     = null
}

variable "native_range_mdns_reflector" {
  description = "Native range mDNS reflector"
  type        = bool
  default     = false
}

variable "native_range_translated_subnet" {
  description = "Native range translated subnet"
  type        = string
  default     = null
}

variable "native_range_dhcp_settings" {
  description = "Native range DHCP settings"
  type = object({
    dhcp_type                  = optional(string)
    ip_range                  = optional(string)
    relay_group_id            = optional(string)
    dhcp_microsegmentation    = optional(bool)
  })
  default = null
}

variable "site_location" {
  type = object({
    address      = string
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
    interface_index      = string
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
    id                = optional(string)  # Added to support stable indexing
    interface_index   = optional(string)
    name              = optional(string)
    dest_type         = optional(string)
    local_ip          = optional(string)
    subnet            = optional(string)
    translated_subnet = optional(string)
    vrrp_type         = optional(string)
    network_ranges = optional(list(object({
      id                     = optional(string) # Added to support imports
      name                   = optional(string)
      range_type             = optional(string)
      subnet                 = optional(string)
      local_ip               = optional(string)
      gateway                = optional(string)
      vlan                   = optional(string)
      translated_subnet      = optional(string)
      internet_only          = optional(bool)
      import_id              = optional(string) # Added to support imports
      mdns_reflector         = optional(string)
      dhcp_type              = optional(string)
      dhcp_ip_range          = optional(string)
      dhcp_relay_group_id    = optional(string)
      dhcp_relay_group_name  = optional(string)
      dhcp_microsegmentation = optional(string)
    })), [])
  }))
  default = []
}

variable "license_id" {
  description = "The license ID for the Cato vSocket of license type CATO_SITE, CATO_SSE_SITE, CATO_PB, CATO_PB_SSE.  Example License ID value: 'abcde123-abcd-1234-abcd-abcde1234567'.  Note that licenses are for commercial accounts, and not supported for trial accounts."
  type        = string
  default     = null
}

variable "license_bw" {
  description = "The license bandwidth number for the cato site, specifying bandwidth ONLY applies for pooled licenses.  For a standard site license that is not pooled, leave this value null. Must be a number greater than 0 and an increment of 10."
  type        = string
  default     = null
}