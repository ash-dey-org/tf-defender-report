variable "env" {
  type        = string
  description = "The environment variable"
}

variable "proj" {
  type        = string
  description = "The project name"
}

variable "region" {
  type        = string
  description = "The region name"
}

variable "company" {
  type        = string
  description = "The company name"
}

/*
variable "location" {
  type        = string
  description = "Location to deploy communication resource"
}
*/

variable "kvname" {
  type        = string
  description = "name suffix for kv"
}

variable "service_plan_sku" {
  type        = string
  description = "function app service plan"
}

variable "str_name" {
  type        = string
  description = "storage name"
}

variable "storage_account_replication_type" {
  type        = string
  description = "The replication type for azure storage account"
}

variable "common_tags" {
  description = "The tags to associate with your network and subnets."
  type        = map(string)

  default = {
    APP    = "core-network"
    OWNER  = "ICT"
    DEPLOY = "Terraform"
  }
}

variable "extra_tags" {
  description = "Extra tags specific to environment"
  type        = map(string)
  default     = null
}

variable "az_devops_ip" {
  type        = list(string)
  description = "Azure devops IP range"
  default     = ["20.37.194.0/24", "20.42.226.0/24"]
}

# vnet.tf
variable "vnet_address_space" {
  type        = list(string)
  description = "VNET address space"
}

variable "fn_sn_fa" {
  type        = list(string)
  description = "function subnet address space for main function"
}

variable "pe_fa_address_space" {
  type        = list(string)
  description = "private endpoint subnet address space"
}

/*
variable "str_address_space" {
  type        = list(string)
  description = "storage subnet address space"
}

*/

