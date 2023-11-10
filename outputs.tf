### Resource Group Ouputs
output "rg_id" {
  description = "The ID of the Resource Group"
  value       = try(azurerm_resource_group.this[0].id, null)
}
output "rg_name" {
  description = "The Name of the Resource Group"
  value       = try(azurerm_resource_group.this[0].name, null)
}
output "rg_location" {
  description = "Region of the Resource Group"
  value       = try(azurerm_resource_group.this[0].location, null)
}
output "rg_managedby" {
  description = "Account managing the Resource Group"
  value       = try(azurerm_resource_group.this[0].managed_by, null)
}

### Security Group Outputs
output "nsg_id" {
  description = "The ID of the Network Security Group"
  value       = try(azurerm_network_security_group.this[0].id, null)
}
output "nsg_name" {
  description = "The Name of the Network Security Group"
  value       = try(azurerm_network_security_group.this[0].name, null)
}
output "nsg_rg_name" {
  description = "The name of the Resource Group associated with the NSG"
  value       = try(azurerm_network_security_group.this[0].resource_group_name, null)
}
output "nsg_location" {
  description = "The location of the NSG"
  value       = try(azurerm_network_security_group.this[0].location, null)
}

### VNet Outputs
output "vnet_id" {
  description = "The ID of the VNet"
  value       = try(azurerm_virtual_network.this[0].id, null)
}
output "vnet_name" {
  description = "The name of the VNet"
  value       = try(azurerm_virtual_network.this[0].name, null)
}
output "vnet_rg_name" {
  description = "The Resource Group Name associated with the VNet"
  value       = try(azurerm_virtual_network.this[0].resource_group_name, null)
}
output "vnet_location" {
  description = "The region the VNet is deployed in"
  value       = try(azurerm_virtual_network.this[0].location)
}
output "vnet_address_space" {
  description = "The CIDR address space associated with the VNet"
  value       = try(azurerm_virtual_network.this[0].address_space, null)
}
output "vnet_guid" {
  description = "The GUID of the VNet"
  value       = try(azurerm_virtual_network.this[0].guid, null)
}


# DDoS Protection Plan Outputs
output "ddos_id" {
  description = "The ID of the DDoS protection plan"
  value       = try(azurerm_network_ddos_protection_plan.this[0].id, null)
}
output "ddos_name" {
  description = "The name of the DDoS Protection Plan"
  value       = try(azurerm_network_ddos_protection_plan.this[0].name, null)
}
output "ddos_rg_name" {
  description = "The name of the RG associated with the DDoS"
  value       = try(azurerm_network_ddos_protection_plan.this[0].resource_group_name, null)
}
output "ddos_location" {
  description = "The region which the DDoS Protection Plan is present in"
  value       = try(azurerm_network_ddos_protection_plan.this[0].location, null)
}

# Key Vault Outputs
output "kv_id" {
  description = "The ID of the Key Vault created"
  value       = try(azurerm_key_vault.this[0].id, null)
}
output "kv_name" {
  description = "The name of the Key Vault created"
  value       = try(azurerm_key_vault.this[0].name, null)
}
output "kv_uri" {
  description = "The URI for the Key Vault created"
  value       = try(azurerm_key_vault.this[0].vault_uri, null)
}
output "kv_location" {
  description = "Region which the Key Vault is deployed in"
  value       = try(azurerm_key_vault.this[0].location, null)
}
output "kv_tenant_id" {
  description = "Tenant ID associated with the Key Vault"
  value       = try(azurerm_key_vault.this[0].tenant_id, null)
}
