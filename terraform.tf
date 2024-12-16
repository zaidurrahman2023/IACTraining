terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"

    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-terraformtrain"
    storage_account_name = "saterraformtrain001"
    container_name       = "terraform-state"
    key                  = "terraform.tfstate"
    use_azuread_auth     = true
  }
}


