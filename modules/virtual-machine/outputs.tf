output "name" {
  value = azurerm_virtual_machine.azp_agent_vm.*.name
}
