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

## 0.0.4 (2025-09-11)

### Features
- Removed network ranges from local module and use the public https://registry.terraform.io/modules/catonetworks/network-ranges-bulk/cato/latest as a nested module
- Fixed logic in interface mapping to support all attributes and map native_interface and native_range properly
- Updated outputs