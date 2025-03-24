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

variable "branch" {
  description = "Nome do branch do repositorio"
}

variable "repository" {
  description = "Endereço do repositorio"
}

variable "output_location" {
  description = "Local de saída"
}

variable "api_location" {
  description = "Configuracoes"
}

variable "app_location" {
  description = "Local do app"
}