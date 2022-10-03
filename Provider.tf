terraform {
  required_providers {
    azurerm = {
      version = "= 3.20.0"
    }
  }
}

provider "azurerm" {
  features {}
}
