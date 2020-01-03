provider "azurerm" {
  version = "~>1.39"
}

resource "azurerm_resource_group" "azp_build_agents_group" {
  name     = var.name
  location = var.location
  tags     = var.tags
}
