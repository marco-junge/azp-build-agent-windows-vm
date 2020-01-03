provider "azurerm" {
  version = "~>1.39"
}

resource "azurerm_virtual_network" "azp_private_vnet" {
  name                = var.name
  resource_group_name = var.resource_group
  location            = var.location
  tags                = var.tags
  
  address_space       = var.address_space

  subnet {
    name           = var.subnet_name
    address_prefix = var.subnet_address_prefix
  }
}
