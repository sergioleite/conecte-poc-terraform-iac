resource "azurerm_cosmosdb_account" "cosmosdb" {
  name                      = var.cosmosdb_name
  resource_group_name       = var.rg-name
  location                  = var.location
  tags = var.tags
  offer_type                = "Standard"
  kind                      = "MongoDB"
  mongo_server_version = "4.0"
  enable_automatic_failover = false
  public_network_access_enabled = false

  consistency_policy {
    consistency_level = "Session"
  }
  capabilities {
    name = "EnableMongo"
  }
  capabilities {
    name = "EnableServerless"
  }
  
  geo_location {
    location = var.location
    failover_priority = 0
  }
}

data "azurerm_subnet" "snet-data" {
  name                 = "snet-${var.namespace}-app"
  virtual_network_name = "ed-${var.env}-vnet-use2-001"
  resource_group_name  = "ed-${var.env}-rg-network"
}

resource "azurerm_private_endpoint" "pep-cosmosmongo" {
  name                = "ed-${var.env}-pep-cosmosmongo-${var.namespace}"
  resource_group_name = var.rg-name
  location            = var.location
  subnet_id           = data.azurerm_subnet.snet-data.id

  private_service_connection {
    name                           = "ed-${var.env}-psc-cosmosmongo-${var.namespace}"
    private_connection_resource_id = azurerm_cosmosdb_account.cosmosdb.id
    subresource_names              = [ "MongoDB" ]
    is_manual_connection           = false
  }
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = var.private_dns_zone_hub_id
  }
}


