output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}
 
output "acr_admin_username" {
  value = azurerm_container_registry.acr.admin_username
}
 
output "aks_kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}
 
output "resource_group" {
  value = azurerm_resource_group.rg.name
}
 
output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.law.id
}
