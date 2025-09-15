data "azurerm_client_config" "current" {}
 
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.prefix}-aks"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.prefix}-k8s"
 
  default_node_pool {
    name            = "agentpool"
    node_count      = var.node_count
    vm_size         = var.node_vm_size
    vnet_subnet_id  = var.private_subnet_id
    zones      = var.node_zones  
  }
 
  identity {
    type = "SystemAssigned"
  }
 
  role_based_access_control_enabled = true
 
  network_profile {
    network_plugin = "azure"
    load_balancer_sku = "standard"
    service_cidr = "10.1.0.0/16"
    dns_service_ip = "10.1.0.10"
  }
 
 oms_agent {
    enabled = true
    log_analytics_workspace_id = azurerm_log_analytics_workspace.insights.id
  }

  azure_policy_enabled = true
}
 
# Allow AKS kubelet identity to pull from ACR
resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}
