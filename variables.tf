#### Common variables
variable "name-prefix" {
  description = "value to be used as prefix for all resources"
  type        = string
}
variable "primary_region" {
  description = "primary region to deploy resources"
  type        = string
}
variable "default_tags" {
  description = "map of tags to be applied to all resources"
  type        = map(string)
  default     = {}
}

### Resource group variables
variable "create_rg" {
  description = "create resource group"
  type        = bool
  default     = true
}
variable "rg_location" {
  description = "location of resource group"
  type        = string
  default     = ""
}
variable "rg_tags" {
  description = "map of tags to be applied to resource group"
  type        = map(string)
  default     = {}
}
### Security group variables
variable "create_sg" {
  description = "create security group"
  type        = bool
  default     = true
}
variable "sg_location" {
  description = "location of security group"
  type        = string
  default     = ""
}
variable "sg_tags" {
  description = "map of tags to be applied to security group"
  type        = map(string)
  default     = {}
}
variable "sg_rg_name" {
  description = "resource group name for security group"
  type        = string
  default     = ""
}

### Virtual network variables
variable "create_vnet" {
  description = "create virtual network"
  type        = bool
  default     = true
}
variable "vnet_location" {
  description = "location of virtual network"
  type        = string
  default     = ""
}
variable "vnet_rg_name" {
  description = "resource group name for virtual network"
  type        = string
  default     = ""
}
variable "vnet_cidr" {
  description = "CIDR block for virtual network"
  type        = string
  validation {
    condition     = can(cidrhost(var.vnet_cidr, 0)) && try(cidrhost(var.vnet_cidr, 0), null) == split("/", var.vnet_cidr)[0]
    error_message = "InvalidCIDRNotation: The Address Space is not a correctly formated CIDR, or the address prefix is invalid for the CIDR's size"
  }
}
variable "bgp_community" {
  description = "BGP community for virtual network"
  type        = string
  default     = null
}
variable "vnet_ddos_id" {
  description = "DDoS protection plan ID for virtual network"
  type        = string
  default     = null
}
variable "vnet_edge_zone" {
  description = "Edge zone for virtual network"
  type        = string
  default     = null
}
variable "vnet_tags" {
  description = "map of tags to be applied to virtual network"
  type        = map(string)
  default     = {}
}

### DDoS protection plan variables
variable "create_ddos" {
  description = "create DDoS protection plan"
  type        = bool
  default     = false
}
variable "ddos_location" {
  description = "location of DDoS protection plan"
  type        = string
  default     = ""
}
variable "ddos_tags" {
  description = "map of tags to be applied to DDoS protection plan"
  type        = map(string)
  default     = {}
}
variable "ddos_rg_name" {
  description = "resource group name for DDoS protection plan"
  type        = string
  default     = ""
}

### Main Subnet variables
variable "main_subnets_rg_name" {
  description = "resource group name for main subnet"
  type        = string
  default     = ""
}
variable "main_subnets_vnet_name" {
  description = "virtual network name for main subnet"
  type        = string
  default     = ""
}
variable "main_subnets_service_endpoints" {
  description = "service endpoints for main subnet"
  type        = list(string)
  default     = []
}

### Service Dedicated Subnet variables
variable "service_subnets_rg_name" {
  description = "resource group name for service dedicated subnet"
  type        = string
  default     = ""
}
variable "service_subnets_vnet_name" {
  description = "virtual network name for service dedicated subnet"
  type        = string
  default     = ""
}
variable "service_subnets_service_endpoints" {
  description = "service endpoints for service dedicated subnet"
  type        = list(string)
  default     = []
}
variable "service_subnets_delegations" {
  description = "delegations for service dedicated subnet"
  type        = list(string)
  default     = []
}

### Key Vault variables
variable "create_kv" {
  description = "create key vault"
  type        = bool
  default     = true
}
variable "kv_location" {
  description = "location of key vault"
  type        = string
  default     = ""
}
variable "kv_rg_name" {
  description = "resource group name for key vault"
  type        = string
  default     = ""
}
variable "kv_tags" {
  description = "map of tags to be applied to key vault"
  type        = map(string)
  default     = {}
}
variable "kv_sku" {
  description = "SKU for key vault"
  type        = string
  default     = "standard"
}
variable "kv_soft_delete_retention_days" {
  description = "soft delete retention days for key vault"
  type        = number
  default     = 90
}
variable "kv_purge_protection_enabled" {
  description = "purge protection enabled for key vault"
  type        = bool
  default     = false
}
variable "kv_network_acls_ip_rules" {
  description = "network ACLs IP rules for key vault"
  type        = list(string)
  default     = []
}
variable "kv_network_acls_virtual_network_subnet_ids" {
  description = "network ACLs virtual network subnet IDs for key vault"
  type        = list(string)
  default     = []
}
variable "kv_network_acls_bypass" {
  description = "network ACLs bypass for key vault"
  type        = string
  default     = "AzureServices"
}
variable "kv_network_acls_default_action" {
  description = "network ACLs default action for key vault"
  type        = string
  default     = "Deny"
}
variable "kv_tenant_id" {
  description = "tenant ID for key vault"
  type        = string
  default     = null
}
variable "kv_deploy_access_policy" {
  description = "deploy access policy for key vault"
  type        = bool
  default     = false
}
variable "kv_disk_encryption_enabled" {
  description = "disk encryption enabled for key vault"
  type        = bool
  default     = false
}
variable "kv_rbac_enabled" {
  description = "RBAC enabled for key vault"
  type        = bool
  default     = false
}
variable "kv_template_deployment_enabled" {
  description = "template deployment enabled for key vault"
  type        = bool
  default     = false
}
