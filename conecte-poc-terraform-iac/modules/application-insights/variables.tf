variable "location" {
  description = "Região da Azure para criação do recurso"
}

variable "rg-name" {
  description = "Nome do resource group"
}

variable "insights_name" {
  description = "Nome do App Insights"
}

variable "insights_type" {
  description = "insights_type"
}

variable "tags" {
  type = map
}