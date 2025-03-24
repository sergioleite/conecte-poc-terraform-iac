variable "location" {
  description = "Região da Azure para criação do recurso"
}

variable "rg-name" {
  description = "Nome do resource group"
}

variable "name" {
  description = "Nome do microserviço"
}


variable "env" {
  description = "Nome do microserviço"
}

variable "sufixo" {
  description = "Nome do microserviço"
}


variable "tags" {
  type = map 
}

variable "app_service_plan_id" {
  description = "Nome do app service plan"
}

variable "insights_name" {
  description = "Application insigths name"
}

variable "namespace" {
  description = "Identificador aplicacao"
}

variable "private_dns_zone_hub_id" {
  description = "DNS zone"
}

variable "app_settings" {
  description = "Configuracoes"
}