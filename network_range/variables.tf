variable "site_id" {
  description = "Unique identifier of the site."
  type        = string
  default     = null
}

variable "interface_id" {
  description = "ID of the network interface to assign the network range to."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the network range."
  type        = string
  default     = null
}

variable "range_type" {
  description = "Type of the network range. Possible values: Direct, Native, Routed, SecondaryNative, VLAN."
  type        = string
  default     = null
  validation {
    condition     = contains(["Direct", "Native", "Routed", "SecondaryNative", "VLAN"], var.range_type)
    error_message = "range_type must be one of the following: Direct, Native, Routed, SecondaryNative, VLAN."
  }
}

variable "subnet" {
  description = "The subnet in CIDR notation."
  type        = string
  default     = null
  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]{1,2}$", var.subnet))
    error_message = "subnet must be a valid CIDR notation (e.g., 192.168.1.0/24)."
  }
}

variable "translated_subnet" {
  description = "Translated NAT subnet configuration"
  type        = string
  default     = null
}

variable "local_ip" {
  description = "The local IP address."
  type        = string
  default     = null
  # validation {
  #   condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}$", var.local_ip))
  #   error_message = "local_ip must be a valid IPv4 address (e.g., 192.168.1.1)."
  # }
}

variable "gateway" {
  description = "The gateway IP address."
  type        = string
  default     = null
  # validation {
  #   condition     = var.vlan == null || can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}$", var.gateway))
  #   error_message = "gateway must be a valid IPv4 address (e.g., 192.168.1.1)."
  # }
}

variable "vlan" {
  description = "The VLAN ID to be used. Must be null or an integer between 1 and 4094."
  type        = number
  default     = null
  # validation {
  #   condition     = var.vlan == null || (var.vlan >= 1 && var.vlan <= 4094)
  #   error_message = "vlan must be null or an integer between 1 and 4094."
  # }
}

variable "dhcp_settings" {
  description = "DHCP settings for the network range. Only applicable if range_type is VLAN or Native."
  type = object({
    dhcp_type = string
    ip_range  = string
  })
  default = null
  # validation {
  #   condition = var.dhcp_settings == null || (
  #     contains(["VLAN", "Native"], var.range_type) &&
  #     var.dhcp_settings.dhcp_type == "DHCP_RANGE" &&
  #     can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}-([0-9]{1,3}\\.){3}[0-9]{1,3}$", var.dhcp_settings.ip_range))
  #   )
  #   error_message = "dhcp_settings must be provided only if range_type is VLAN or Native, with a valid dhcp_type of 'DHCP_RANGE' and ip_range in the format '192.168.200.100-192.168.200.150'."
  # }
}