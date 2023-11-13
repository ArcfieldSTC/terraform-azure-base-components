provider "azurerm" {
  features {}
}
locals {
  vnet_ddos_list       = [var.vnet_ddos_id, try(azurerm_network_ddos_protection_plan.this[0].id, null)]
  vnet_ddos            = compact(local.vnet_ddos_list)
  subnet_count         = 5
  total_addresses      = pow(2, 32 - parseint(split("/", var.vnet_cidr)[1], 10))
  address_chunks       = floor(local.total_addresses / local.subnet_count)
  new_bits             = parseint(split("/", var.vnet_cidr)[1], 10) - floor(log(local.address_chunks, 2))
  K8s_subnet           = cidrsubnet(var.vnet_cidr, local.new_bits, 0)
  VM_subnet            = cidrsubnet(var.vnet_cidr, local.new_bits, 1)
  VDI_subnet           = cidrsubnet(var.vnet_cidr, local.new_bits, 2)
  AG_subnet            = cidrsubnet(var.vnet_cidr, local.new_bits, 3)
  dedicated_svc_subnet = cidrsubnet(var.vnet_cidr, local.new_bits, 4)
  subnet_names         = ["K8s", "VM", "VDI", "AG"]
  subnets              = [local.K8s_subnet, local.VM_subnet, local.VDI_subnet, local.AG_subnet]
  delegated_newbits    = 27 - parseint(split("/", local.dedicated_svc_subnet)[1], 10)
}
# Creation of the base resouce group
resource "azurerm_resource_group" "this" {
  count    = var.create_rg == true ? 1 : 0
  name     = "${var.name-prefix}-resource-group"
  location = coalesce(var.rg_location, var.primary_region)
  tags     = merge(var.default_tags, var.rg_tags)
}
# Creation of the base NSG
resource "azurerm_network_security_group" "this" {
  count               = var.create_sg == true ? 1 : 0
  name                = "${var.name-prefix}-nsg"
  location            = coalesce(var.sg_location, var.primary_region)
  resource_group_name = coalesce(var.sg_rg_name, azurerm_resource_group.this[0].name)
  tags                = merge(var.default_tags, var.sg_tags)
}
# Creation of the base VNet
resource "azurerm_virtual_network" "this" {
  count               = var.create_vnet == true ? 1 : 0
  name                = "${var.name-prefix}-vnet"
  location            = coalesce(var.vnet_location, var.primary_region)
  resource_group_name = coalesce(var.vnet_rg_name, azurerm_resource_group.this[0].name)
  address_space       = [var.vnet_cidr]
  bgp_community       = var.bgp_community
  dynamic "ddos_protection_plan" {
    for_each = local.vnet_ddos
    content {
      id     = coalesce(var.vnet_ddos_id, azurerm_network_ddos_protection_plan.this[0].id)
      enable = true
    }
  }
  edge_zone = var.vnet_edge_zone
  tags      = merge(var.default_tags, var.vnet_tags)
}
# Creation of DDoS Protection Plan
resource "azurerm_network_ddos_protection_plan" "this" {
  count               = var.create_ddos == true ? 1 : 0
  name                = "${var.name-prefix}-ddos"
  location            = coalesce(var.ddos_location, var.primary_region)
  resource_group_name = coalesce(var.ddos_rg_name, azurerm_resource_group.this[0].name)
  tags                = merge(var.default_tags, var.ddos_tags)
}
# Creation of Subnets
resource "azurerm_subnet" "main" {
  count                                         = length(local.subnet_names)
  name                                          = "${local.subnet_names[count.index]}-subnet"
  resource_group_name                           = coalesce(var.main_subnets_rg_name, azurerm_resource_group.this[0].name)
  virtual_network_name                          = coalesce(var.main_subnets_vnet_name, azurerm_virtual_network.this[0].name)
  address_prefixes                              = [local.subnets[count.index]]
  private_endpoint_network_policies_enabled     = false
  private_link_service_network_policies_enabled = false
  service_endpoints                             = var.main_subnets_service_endpoints
}
resource "azurerm_subnet" "svc_dedicated" {
  count                                         = length(var.service_subnets_delegations)
  name                                          = "${split("/", var.service_subnets_delegations[count.index])[1]}-subnet"
  resource_group_name                           = coalesce(var.service_subnets_rg_name, azurerm_resource_group.this[0].name)
  virtual_network_name                          = coalesce(var.service_subnets_vnet_name, azurerm_virtual_network.this[0].name)
  address_prefixes                              = [cidrsubnet(local.dedicated_svc_subnet, local.delegated_newbits, count.index)]
  private_endpoint_network_policies_enabled     = false
  private_link_service_network_policies_enabled = false
  service_endpoints                             = var.service_subnets_service_endpoints
}
# Creation of Key Vault
resource "azurerm_key_vault" "this" {
  count                           = var.create_kv == true ? 1 : 0
  name                            = "${var.name-prefix}-kv"
  location                        = coalesce(var.kv_location, var.primary_region)
  resource_group_name             = coalesce(var.kv_rg_name, azurerm_resource_group.this[0].name)
  sku_name                        = var.kv_sku
  tenant_id                       = var.kv_tenant_id
  enabled_for_deployment          = var.kv_deploy_access_policy
  enabled_for_disk_encryption     = var.kv_disk_encryption_enabled
  enabled_for_template_deployment = var.kv_template_deployment_enabled
  enable_rbac_authorization       = var.kv_rbac_enabled
  network_acls {
    bypass                     = var.kv_network_acls_bypass
    default_action             = var.kv_network_acls_default_action
    ip_rules                   = var.kv_network_acls_ip_rules
    virtual_network_subnet_ids = compact(concat(azurerm_subnet.main[*].id, azurerm_subnet.svc_dedicated[*].id, var.kv_network_acls_virtual_network_subnet_ids))
  }
  tags = merge(var.default_tags, var.kv_tags)
}
