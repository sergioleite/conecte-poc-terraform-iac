data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                        = var.name_key_vault
  location                    = var.location
  resource_group_name         = var.rg-name
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  public_network_access_enabled = false
  #tags                        = var.tags
  sku_name = "standard"

  access_policy {
    tenant_id = var.tenant_id
    object_id = var.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Set",
      "Get",
      "Delete",
      "Purge",
      "Recover"
    ]

    storage_permissions = [
      "Get",
    ]
  } 
}

data "azurerm_subnet" "snet-data" {
  name                 = "snet-${var.namespace}-app"
  virtual_network_name = "ed-${var.env}-vnet-use2-001"
  resource_group_name  = "ed-${var.env}-rg-network"
}

resource "azurerm_private_endpoint" "pep-kv" {
  name                = "ed-${var.env}-pep-kv-${var.namespace}"
  resource_group_name = var.rg-name
  location            = var.location
  subnet_id           = data.azurerm_subnet.snet-data.id

  private_service_connection {
    name                           = "ed-${var.env}-psc-kv-${var.namespace}"
    private_connection_resource_id = azurerm_key_vault.kv.id
    subresource_names              = [ "vault" ]
    is_manual_connection           = false
  }
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = var.private_dns_zone_hub_id
  }
}


