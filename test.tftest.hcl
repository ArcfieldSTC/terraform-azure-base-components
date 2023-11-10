provider "azurerm" {
  features {
    api_management {
      purge_soft_delete_on_destroy = true
      recover_soft_deleted         = true
    }
    app_configuration {
      purge_soft_delete_on_destroy = true
      recover_soft_deleted         = true
    }
    key_vault {
      purge_soft_delete_on_destroy                            = true
      purge_soft_deleted_certificates_on_destroy              = true
      purge_soft_deleted_hardware_security_modules_on_destroy = true
      purge_soft_deleted_keys_on_destroy                      = true
      purge_soft_deleted_secrets_on_destroy                   = true
      recover_soft_deleted_certificates                       = true
      recover_soft_deleted_key_vaults                         = true
      recover_soft_deleted_keys                               = true
      recover_soft_deleted_secrets                            = true
    }
    managed_disk {
      expand_without_downtime = true
    }
    subscription {
      prevent_cancellation_on_destroy = false
    }
    virtual_machine {
      delete_os_disk_on_deletion     = true
      graceful_shutdown              = false
      skip_shutdown_and_force_delete = false
    }
    virtual_machine_scale_set {
      force_delete                  = false
      roll_instances_when_required  = true
      scale_to_zero_before_deletion = true
    }
  }
  use_oidc = true
}

variables {
    name-prefix = "stc-test"
    primary_region = "USGov Virginia"
    default_tags = {
        Environment = "Test"
        CostType = "OH"
    }
    vnet_cidr = "192.167.0.0/16"
    kv_tenant_id = "7d11087c-b2fa-4fe4-b0cc-65e2c824dcd9"
    service_subnets_delegations = ["Microsoft.ContainerService/managedClusters"]
    main_subnets_service_endpoints = [
        "Microsoft.ContainerRegistry",
        "Microsoft.KeyVault",
        "Microsoft.Storage"
    ]
    service_subnets_service_endpoints = [
        "Microsoft.ContainerRegistry",
        "Microsoft.KeyVault",
        "Microsoft.Storage"
    ]
}

run "test_module" {
    command = apply
    // module {
    //     source = "./tests/setup"
    // }
    
    assert {
        condition = azurerm_resource_group.this[0].name == "stc-test-resource-group"
        error_message = "Invalid name for resource group"
    }
    assert {
        condition = azurerm_network_security_group.this[0].name == "stc-test-nsg"
        error_message = "Invalid name for NSG"
    }
    assert {
      condition = azurerm_virtual_network.this[0].name == "stc-test-vnet"
      error_message = "Invalid name for VNet"
    }
    assert {
      condition = azurerm_subnet.main[0].name == "K8s-subnet"
      error_message = "Invalid name for K8 Subnet"
    }
    assert {
      condition = azurerm_key_vault.this[0].name == "stc-test-kv"
      error_message = "Invalid name for Key Vault"
    }
}
