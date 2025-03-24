resource "azurerm_application_insights" "edge-appi" {
  name                = var.insights_name
  location            = var.location
  resource_group_name = var.rg-name
  application_type    = var.insights_type
  tags = var.tags
}