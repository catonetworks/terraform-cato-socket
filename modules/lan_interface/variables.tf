variable "site_id" {
  description = "Unique identifier of the site."
  type        = string
  default     = null
}

variable "interface_id" {
  description = "The ID of the interface."
  type        = string
}

variable "name" {
  description = "The name of the interface."
  type        = string
  default     = null
}

variable "dest_type" {
  description = "SocketInterface destination type (https://api.catonetworks.com/documentation/#definition-SocketInterfaceDestType)"
  type        = string
  default     = null
}

variable "local_ip" {
  description = "Local IP address of the LAN interface"
  type        = string
  default     = null
}

variable "subnet" {
  description = "Subnet of the LAN interface in CIDR notation"
  type        = string
  default     = null
}

variable "translated_subnet" {
  description = "Translated NAT subnet configuration"
  type        = string
  default     = null
}

variable "vrrp_type" {
  description = "VRRP Type (https://api.catonetworks.com/documentation/#definition-VrrpType)"
  type        = string
  default     = null
}

variable "network_ranges" {
  description = "List of network ranges for the interface."
  type = list(object({
    name              = string
    range_type        = string
    subnet            = string
    local_ip          = string
    translated_subnet = string
    gateway           = string
    vlan              = number
    dhcp_settings = object({
      dhcp_type = string
      ip_range  = string
    })
  }))
  default = []
}