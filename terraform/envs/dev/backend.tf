terraform {
  backend "azurerm" {
    resource_group_name  = "<BOOTSTRAP_RG>"                 # from bootstrap output
    storage_account_name = "<BOOTSTRAP_STORAGE_ACCOUNT>"    # from bootstrap output
    container_name       = "<BOOTSTRAP_CONTAINER>"          # usually "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}