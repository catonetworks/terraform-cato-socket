# Changelog

## 0.0.1 (2025-04-27)

### Features
- Initial version of AWS physical socket module, support socket, cato or wan interface, lan interface configurations and network_ranges per lan interface. 

## 0.0.2 (2025-04-27)

### Features
- Added optional license resource and inputs used for commercial site deployments

## 0.0.3 (2025-05-19)

### Features
- Update module to support modifying networks for default LAN native range interfaces

## 0.0.5 (2025-09-12)

### Features
- Removed network ranges from local module and use the public https://registry.terraform.io/modules/catonetworks/network-ranges-bulk/cato/latest as a nested module
- Fixed logic in interface mapping to support all attributes and map native_interface and native_range properly
- Updated outputs
- Updated internal module path to use public modules

## 0.0.6 (2025-09-15)

- Added default_interface_network_ranges variable to support network ranges for the default/native LAN interface
- Added default_interface_network_ranges output for created default interface network ranges  
- Added cato_network_range.default_interface_ranges resource for managing default interface ranges
- Enhanced LAN interface filtering to require both interface_index and dest_type to be non-null
- Simplified LAN interface creation logic by removing complex connection type mapping
- Updated dest_type variable description to clarify LAN interface creation behavior
- Made state_code optional in site_location variable
- Updated README documentation with new variable and output information