variable "location" { default = "eastus" }
variable "resource_group" { default = "tf-backend-rg" }
variable "storage_account_name" { description = "must be globally unique" }
variable "container_name" { default = "tfstate" }