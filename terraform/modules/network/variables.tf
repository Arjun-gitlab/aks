variable "prefix" {}
variable "resource_group_name" {}
variable "location" {}
variable "vnet_cidr" { default = "10.0.0.0/16" }
 
variable "public_subnet_1_cidr" { default = "10.0.1.0/24" }
variable "public_subnet_2_cidr" { default = "10.0.2.0/24" }
variable "private_subnet_1_cidr" { default = "10.0.10.0/24" }
variable "private_subnet_2_cidr" { default = "10.0.11.0/24" }