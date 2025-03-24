variable "location" {
  description = "Região da Azure para criação do recurso"
}

variable "rg-name" {
  description = "Nome do resource group"
}

variable "cosmosdb_name" {
  description = "Nome do cosmos db"
}


variable "tags" {
  type = map 
}

variable "namespace" {
  description = "Identificador aplicacao"
}

variable "env" {
  description = "Ambiente SDX|DEV|HML"
}

variable "private_dns_zone_hub_id" {
  description = "DNS zone"
}
