variable "storage_account_name" {
  description = "Nome da storage account"
}

variable "container_name" {
  description = "Nome do container"
}

variable "location" {
  description = "Região da Azure para criação do recurso"
}

variable "resource_group_name" {
  description = "Nome do resource group"
}

variable "tags" {
  type = map(any)
}
