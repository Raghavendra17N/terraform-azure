terraform {
    required_version                         =           ">= 0.12"  
    required_providers {
    azurerm = {
            source                          =           "hashicorp/azurerm"
            version                         =           "2.83.0"
    }
  }
    backend "azurerm" {
            storage_account_name            =           var.storage_account_name
            container_name                  =           var.container_name
            key                             =           "prod.terraform.tfstate"
            use_msi                         =           true
            subscription_id                 =           var.azure_subscription_id
            tenant_id                       =           var.azure_tenant_id
  }
}

provider "azurerm" {

            subscription_id                =           var.azure_subscription_id
            client_id                      =           var.azure_client_id
            client_secret                  =           var.azure_client_secret
            tenant_id                      =           var.azure_tenant_id
}