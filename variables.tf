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
      name              = string
      range_type        = string
      subnet            = string
      local_ip          = string
      gateway           = string
      vlan              = number
      translated_subnet = string
      dhcp_settings = object({
        dhcp_type = string
        ip_range  = string
      })
    }))
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