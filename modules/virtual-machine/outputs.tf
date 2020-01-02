output "name" {
  value = azurerm_virtual_machine_extension.azp_agent_vm_prepare_data_disk.*.virtual_machine_name
}
