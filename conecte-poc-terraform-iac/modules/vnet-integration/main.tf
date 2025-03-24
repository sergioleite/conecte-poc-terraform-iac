data "azurerm_linux_function_app" "function_app" {
  name                = var.name
  resource_group_name = var.rg-name
}

resource "azurerm_app_service_virtual_network_swift_connection" "vnet-integration" {
  app_service_id = data.azurerm_linux_function_app.function_app.id
  subnet_id      = var.subnet_id_integration
}