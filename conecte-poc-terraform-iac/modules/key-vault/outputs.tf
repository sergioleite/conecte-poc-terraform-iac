output "key_vault_name" {
    value = azurerm_key_vault.kv.name
}

output "azurerm_key_vault_out_key_vault_id" {
    value = azurerm_key_vault.kv.id
}


output "kv" {
  value = azurerm_key_vault.kv
  description = "Objeto Key Vault completo"
}