provider "azurerm" {
  version = "~>1.39"
}

resource "azurerm_virtual_machine_extension" "azp_agent_install_agent" {
  count               = length(var.virtual_machines)
  name                = "${element(var.virtual_machines, count.index)}-azp"
  resource_group_name = var.resource_group
  location            = var.location
  tags                = var.tags

  virtual_machine_name = element(var.virtual_machines, count.index)
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  settings = <<SETTINGS
    {
      "fileUris": [
        "https://raw.githubusercontent.com/marco-junge/azp-build-agent-windows-vm/develop/install-azp-agent.ps1"
      ]
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
      "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File install-azp-agent.ps1 -AzpAccount ${var.azp_account} -PersonalAccessToken ${var.personal_access_token} -PoolName ${var.pool_name} -AgentInstallationPath \"${var.agent_installation_path}\" -AgentWorkPath \"${var.agent_work_path}\" -PreRelease ${var.pre_release}"
    }
PROTECTED_SETTINGS
}
