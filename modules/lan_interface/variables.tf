variable "site_id" {
  description = "Unique identifier of the site."
  type        = string
  default     = null
}

variable "connection_type" {
  description = "Connection type can be SOCKET_AWS1500, SOCKET_AZ1500, SOCKET_ESX1500, SOCKET_X1500, SOCKET_X1600, SOCKET_X1600_LTE, SOCKET_X1700"
  type        = string
}

variable "interface_id" {
  description = "The unique ID of the interface."
  type        = string
  default     = null
}

variable "interface_index" {
  description = "The index of the interface."
  type        = string
  validation {
    condition = contains([
      "WAN1", "WAN2", "LAN", "LAN1", "LAN2", "LTE", "USB1", "USB2",
      "INT_1", "INT_2", "INT_3", "INT_4", "INT_5", "INT_6", "INT_7", "INT_8",
      "INT_9", "INT_10", "INT_11", "INT_12", "INT_13", "INT_14", "INT_15", "INT_16"
    ], var.interface_index)
    error_message = "interface_index must be one of: WAN1, WAN2, LAN, LAN1, LAN2, LTE, USB1, USB2, INT_1 to INT_16."
  }
  default = null
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
    id                     = optional(string) # Added to support imports
    import_id              = optional(string) # Added to support imports
    name                   = optional(string)
    range_type             = optional(string)
    subnet                 = optional(string)
    local_ip               = optional(string)
    gateway                = optional(string)
    vlan                   = optional(string)
    translated_subnet      = optional(string)
    internet_only          = optional(bool)
    mdns_reflector         = optional(string)
    dhcp_type              = optional(string)
    dhcp_ip_range          = optional(string)
    dhcp_relay_group_id    = optional(string)
    dhcp_relay_group_name  = optional(string)
    dhcp_microsegmentation = optional(string)
  }))
  default = []
}
