variable "location" {
  description = "Região da Azure para criação do recurso"
}

variable "rg-name" {
  description = "Nome do resource group"
}

variable "tags" {
  type = map 
}