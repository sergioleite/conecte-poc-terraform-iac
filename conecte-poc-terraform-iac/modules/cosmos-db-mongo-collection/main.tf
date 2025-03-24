resource "azurerm_cosmosdb_mongo_collection" "store" {
  name                = var.collection_name
  resource_group_name = var.rg-name
  account_name        = var.cosmosdb_account_name
  database_name       = var.database_name
  default_ttl_seconds = "777"
  index {
    keys   = ["_id"]
    unique = true
  } 
}