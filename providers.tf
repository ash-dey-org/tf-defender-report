# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.75.0"
    }
  }

  required_version = ">= 1.5"

  # define terraform cloud targets e.g. organization and workspace
  cloud {}
}

# Define credential details for the provider
provider "azurerm" {
  use_oidc = true
  features {}
  skip_provider_registration = "true"
}

