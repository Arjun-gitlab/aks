variable "prefix" {}
variable "resource_group_name" {}
variable "location" {}
variable "private_subnet_id" {}
variable "node_count" { default = 2 }
variable "node_vm_size" { default = "Standard_B2s" }
variable "node_zones" {
  type    = list(string)
  default = ["1", "2"]
}
variable "log_analytics_workspace_id" {
  type        = string
  description = "The ID of the Log Analytics Workspace for AKS monitoring"
}
variable "acr_id" {}
