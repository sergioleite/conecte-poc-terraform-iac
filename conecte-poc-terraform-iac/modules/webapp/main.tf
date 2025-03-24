resource "azurerm_linux_web_app" "webapp" {
  name                = "ed-${var.env}-webapp-ed-${var.name}"
  resource_group_name = var.rg-name
  location            = var.location
  service_plan_id     = var.app_service_plan_id
  tags                = var.tags
  https_only          = true
  public_network_access_enabled = false

  site_config         {
    
  }

  app_settings        = var.app_settings
}

data "azurerm_subnet" "snet-data" {
  name                 = "snet-${var.namespace}-app"
  virtual_network_name = "ed-${var.env}-vnet-use2-001"
  resource_group_name  = "ed-${var.env}-rg-network"
}

resource "azurerm_private_endpoint" "pep-function" {
  name                = "ed-${var.env}-pep-webapp-${var.name}-${var.namespace}"
  resource_group_name = var.rg-name
  location            = var.location
  subnet_id           = data.azurerm_subnet.snet-data.id

  private_service_connection {
    name                           = "ed-${var.env}-psc-webapp-${var.name}-${var.namespace}"
    private_connection_resource_id = azurerm_linux_web_app.webapp.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = var.private_dns_zone_hub_id
  }
}