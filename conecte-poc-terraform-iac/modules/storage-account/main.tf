resource "azurerm_storage_account" "storage_account" {
  name                          = var.storage_account_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  account_tier                  = "Standard"
  account_replication_type      = "ZRS"
  public_network_access_enabled = "false"
  // TODO: verificar propriedades no repositorio de referencia

  tags = var.tags
}

resource "azurerm_storage_container" "storage_container" {
  name                  = var.container_name
  storage_account_name  = var.storage_account_name
  container_access_type = "blob"
}
