provider "azurerm" {
  features {}
}
 
# Resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}
 
# Log Analytics
resource "azurerm_log_analytics_workspace" "insights" {
  name                = "${var.prefix}-insights"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  retention_in_days   = 30
  sku                 = "PerGB2018"
}
 
module "network" {
  source              = "../../modules/network"
  prefix              = var.prefix
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  vnet_cidr           = var.vnet_cidr
  public_subnet_1_cidr = var.public_subnet_1_cidr
  public_subnet_2_cidr = var.public_subnet_2_cidr
  private_subnet_1_cidr = var.private_subnet_1_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr
}
 
module "acr" {
  source              = "../../modules/acr"
  acr_name            = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  sku                 = "Standard"
  admin_enabled       = true
}
 
module "aks" {
  source              = "../../modules/aks"
  prefix              = var.prefix
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  private_subnet_id   = module.network.private_subnet_1_id
  node_count          = var.node_count
  node_vm_size        = var.node_vm_size
  node_zones          = [3]
  log_analytics_workspace_id = azurerm_log_analytics_workspace.insights.id
  acr_id              = module.acr.acr_login_server != "" ? module.acr.acr_login_server : null
}
