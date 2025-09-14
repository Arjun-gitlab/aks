terraform {
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = ">=3.0" }
  }
  required_version = ">=1.4.0"
}
 
provider "azurerm" {
  features {}
}
 
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group
  location = var.location
}
 
resource "azurerm_storage_account" "sa" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  allow_nested_items_to_be_public = false
  min_tls_version = "TLS1_2"
}
 
resource "azurerm_storage_container" "tfstate" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}
 
output "storage_account_name" {
  value = azurerm_storage_account.sa.name
}
output "container_name" {
  value = azurerm_storage_container.tfstate.name
}
output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}