################
# Ambiente
#################

variable "env" {
  default     = "__env__"
  description = "Ambiente da Aplicação DEV/HML/PRD"
}

variable "subscription_id" {
  default     = "__subscription_id__"
  description = "ID da Subscription onde o projeto será criado"
}

variable "subscription_id_hub" {
  default = "__subscription_id_hub__"
  description = "ID da Subscription de Hub Services"
}

variable "skip_provider_registration" {
  default     = "false"
  description = "This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers."
}

################
# Networking
################
variable "env_vnet" {
  default = "__env_net__"
  description = "Ambiente onde se encontra a VNET que será usada"
}

variable "subnet_id_integration" {
  default = "__subnet_id_integration__"
  description = "Ambiente onde se encontra a VNET que será usada"
}

################
# Configs Compartilhadas
#################

variable "business" {
  default = "__business__"
  description = "Resource Group onde o projeto será criado"
}

variable "resource_group" {
  default = "__resource_group__"
  description = "Resource Group onde o projeto será criado"
}

variable "location" {
  default = "__location__"
  description = "Região onde os recursos serão alocados"
}

variable "tags" {
  default = {
    Conecte = "dev"
  }
}

variable "stg_name" {
  default = "__stg_name__"
  description = "Nome do Storage Account do Projeto"
}

variable "app_service_plan" {
  default = "__asp_func_001__"
  description = "Service plan"
}

variable "webapp_service_plan" {
  default = "__asp_func_001__"
  description = "Service plan"
}

variable "business_unit" {
  default = "__business_unit__"
  description = "Unidade de negocio"
}

variable "microservice_sufixo" {
  default = "__microservice_sufixo__"
  description = "Sufixo para microservicos (ms) e adpaters (adp) "
}

variable "namespace" {
  default = "__namespace__"
   description = "Ambiente da Aplicação DEV/HML/PRD"
}

variable "insights_name" {
  description = "Application Insights name"
}

variable "insights_type" {
  description = "Application Insights name"
}

variable "health_check_path" {
  description = "Path do health check"
}

variable "tenant_id" {
  description = "Path do health check"
}

################
# Storage Account
#################

variable "storage_account_name" {
  default     = "__storage_account_name__"
  description = "Nome da storage account"
}

variable "container_name" {
  default     = "__container_name__"
  description = "Nome da storage container"
}
