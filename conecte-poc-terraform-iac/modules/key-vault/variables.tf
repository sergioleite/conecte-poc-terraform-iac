variable "name_key_vault" {
    type = string
}

variable "location" {
    type = string
}

variable "rg-name" {
    type = string
}

variable "tenant_id" {
    type = string
}

variable "object_id" {
    type= string
  
}

variable "env" {
  description = "Ambiente de Deploy"
}

variable "business" {
  description = "Negocio que o app pertence"
}

# variable "subnet_id" {
#   description = "Subnet da Inbound da Function"
# }


# variable "private_dns_zone" {
#   description = "Private DNS Zone do PEP da Function"
# }

variable "tags" {
  type = map(any)
}

variable "namespace" {
  description = "Identificador da aplicacao"
}

variable "private_dns_zone_hub_id" {
  description = "DNS zone"
}
