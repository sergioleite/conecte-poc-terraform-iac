terraform {
   backend "azurerm" {
   }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.81.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id            = var.subscription_id
  skip_provider_registration = var.skip_provider_registration
}

provider "azurerm" {
  alias = "hub"

  features {}
  subscription_id = var.subscription_id_hub
  skip_provider_registration = var.skip_provider_registration
}

data "azurerm_client_config" "current" {}

#-----------
# Networking
#-----------
# Subnet
data "azurerm_subnet" "snet-data" {
  name                 = "snet-${var.business_unit}-app"
  virtual_network_name = "ed-${var.env_vnet}-vnet-use2-001"
  resource_group_name  = "ed-${var.env}-rg-network"
}

data "azurerm_subnet" "snet-edge-integration" {
  name                 = "snet-${var.business_unit}-integration"
  virtual_network_name = "ed-${var.env_vnet}-vnet-use2-001"
  resource_group_name  = "ed-${var.env}-rg-network"
}

#--------------
# Resource Group
# #--------------
module "resource-group" {
  source   = "./modules/resource-group"
  rg-name  = var.resource_group
  location = var.location
  tags     = var.tags
}

#--------------
# App Insights
#--------------
module "application-insights" {
  source        = "./modules/application-insights"
  insights_name = "ed-${var.env}-${var.insights_name}"
  insights_type = var.insights_type
  rg-name       = var.resource_group
  location      = var.location
  tags          = var.tags
}

#----------------
# Functions service plan B1
#----------------
resource "azurerm_service_plan" "function_b1_asp" {
  name                = var.app_service_plan
  resource_group_name = var.resource_group
  location            = var.location
  os_type             = "Linux"
  sku_name            = "B1"
  tags                = var.tags
}

#----------------
# WebApp service plan - B2
# #----------------
resource "azurerm_service_plan" "webapp_b2_asp" {
  name                = var.webapp_service_plan
  resource_group_name = var.resource_group
  location            = var.location
  os_type             = "Linux"
  sku_name            = "B2"
  tags                = var.tags
}

#Private DNS - WebApp e Functions
data "azurerm_private_dns_zone" "private_dns_zone_hub" {
  provider            = azurerm.hub
  name                = "privatelink.azurewebsites.net"
  resource_group_name = var.resource_group_private_link
}

#--------------
# Storage Account
# #--------------
module "storage-account" {
  source               = "./modules/storage-account"
  container_name       = var.container_name
  storage_account_name = var.storage_account_name
  resource_group_name  = var.resource_group
  location             = var.location
  tags                 = var.tags
}


#--------------
# Cosmos db 
#--------------
data "azurerm_private_dns_zone" "private_dns_zone_mongo_hub" {
  provider            = azurerm.hub
  name                = "privatelink.mongo.cosmos.azure.com"
  resource_group_name = var.resource_group_private_link
}

module "cosmos-db" {
  source                  = "./modules/cosmos-db"
  cosmosdb_name           = "ed-${var.env}-cosmosmongo-${var.namespace}"
  rg-name                 = var.resource_group
  location                = var.location
  tags                    = var.tags
  env                     = var.env
  namespace               = var.namespace
  private_dns_zone_hub_id = [data.azurerm_private_dns_zone.private_dns_zone_mongo_hub.id]
}

#--------------
# Cosmosdb mongo collection
#--------------
module "cosmos-db-mongo-collection" {
  source                = "./modules/cosmos-db-mongo-collection"
  collection_name       = "store"
  rg-name               = var.resource_group
  cosmosdb_account_name = "ed-${var.env}-cosmosmongo-${var.namespace}"
  database_name         = "db_${var.namespace}_yo-umbrella-store"
}

data "azurerm_private_dns_zone" "private_dns_zone_kv_hub" {
  provider            = azurerm.hub
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.resource_group_private_link
}

#----------------
# WebApp service plan
#----------------
data "azurerm_application_insights" "edge-appi" {
  name                = "ed-${var.env}-${var.insights_name}"
  resource_group_name = var.resource_group
}

// TODO Alterar para webappstatic
module "webapp-frontend" {
  source              = "./modules/webappstatic"
  name                = "store-frontend"
  rg-name             = var.resource_group
  location            = var.location
  app_service_plan_id = azurerm_service_plan.webapp_b2_asp.id
  app_settings = {
    APPLICATIONINSIGHTS_CONNECTION_STRING = data.azurerm_application_insights.edge-appi.connection_string
    APPINSIGHTS_INSTRUMENTATIONKEY        = data.azurerm_application_insights.edge-appi.instrumentation_key
  }
  tags                    = var.tags
  sufixo                  = var.microservice_sufixo
  env                     = var.env
  insights_name           = "ed-${var.env}-${var.insights_name}"
  namespace               = var.namespace
  private_dns_zone_hub_id = [data.azurerm_private_dns_zone.private_dns_zone_hub.id]

  # Configuração específica para Static Web Apps
  branch      = "main"  # Branch do repositório que dispara o build
  repository  = "https://github.com/seu-usuario/seu-repo.git"  # Repositório do código-fonte
  app_location = "www"  # Caminho da build do Angular (ajuste conforme necessário)
  api_location = ""      # Se houver APIs (Node/Azure Functions), defina aqui
  output_location = "www" # Onde os arquivos finais estão localizados
}

module "function_firewall_webapp_frontend" {
  source            = "./modules/webapp-firewall-rule"
  function_app_name = "ed-${var.env}-webapp-ed-store-frontend"
  env               = var.env
  rg-name           = var.resource_group
}

module "webapp-backend" {
  source              = "./modules/webapp"
  name                = "store-backend"
  rg-name             = var.resource_group
  location            = var.location
  app_service_plan_id = azurerm_service_plan.webapp_b2_asp.id
  app_settings = {
    APPLICATIONINSIGHTS_CONNECTION_STRING = data.azurerm_application_insights.edge-appi.connection_string
    APPINSIGHTS_INSTRUMENTATIONKEY        = data.azurerm_application_insights.edge-appi.instrumentation_key
  }
  tags                    = var.tags
  sufixo                  = var.microservice_sufixo
  env                     = var.env
  insights_name           = "ed-${var.env}-${var.insights_name}"
  namespace               = var.namespace
  private_dns_zone_hub_id = [data.azurerm_private_dns_zone.private_dns_zone_hub.id]
}

module "function_firewall_webapp_backend" {
  source            = "./modules/webapp-firewall-rule"
  function_app_name = "ed-${var.env}-webapp-ed-store-backend"
  env               = var.env
  rg-name           = var.resource_group
}

#----------------
# Azure Key Vault
#----------------
module "key-vault" {
  source                  = "./modules/key-vault"
  env                     = var.env
  business                = var.business
  name_key_vault          = "ed-${var.env}-kv-${var.namespace}-app"
  location                = var.location
  rg-name                 = var.resource_group
  tenant_id               = var.tenant_id
  object_id               = data.azurerm_client_config.current.object_id
  tags                    = var.tags
  namespace               = var.namespace
  private_dns_zone_hub_id = [data.azurerm_private_dns_zone.private_dns_zone_kv_hub.id]
}