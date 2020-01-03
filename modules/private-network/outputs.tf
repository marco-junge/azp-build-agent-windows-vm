output "subnet_id" {
  value = element(azurerm_virtual_network.azp_private_vnet.subnet.*.id, 0)
}
