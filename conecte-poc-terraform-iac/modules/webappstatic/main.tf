resource "azurerm_static_site" "this" {
  name                = var.name
  resource_group_name = var.rg-name
  location            = var.location
  tags                = var.tags

  sku_tier = "Free"  # Ou "Standard" se precisar de mais funcionalidades
  branch   = var.branch
  repository_url = var.repository

  build_properties {
    app_location         = var.app_location
    api_location         = var.api_location
    output_location      = var.output_location
  }
}
