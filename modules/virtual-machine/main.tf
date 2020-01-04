provider "azurerm" {
  version = "~>1.39"
}

resource "azurerm_availability_set" "azp_availability_set" {
  name                = var.availability_set_name
  resource_group_name = var.resource_group
  location            = var.location
  tags                = var.tags

  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
}

resource "azurerm_network_interface" "azp_agent_vm_nic" {
  count               = var.quantity
  name                = "${format("${var.prefix}-%02d", count.index + 1)}-nic"
  resource_group_name = var.resource_group
  location            = var.location
  tags                = var.tags

  ip_configuration {
    name                          = "${format("${var.prefix}-%02d", count.index + 1)}-ipconfig"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_managed_disk" "azp_agent_vm_disk" {
  count               = var.quantity
  name                = "${format("${var.prefix}-%02d", count.index + 1)}-data"
  resource_group_name = var.resource_group
  location            = var.location
  tags                = var.tags

  storage_account_type = var.data_disk_storage_account_type
  create_option        = "Empty"
  disk_size_gb         = var.data_disk_size_gb
}

resource "azurerm_virtual_machine" "azp_agent_vm" {
  count               = var.quantity
  name                = format("${var.prefix}-%02d", count.index + 1)
  resource_group_name = var.resource_group
  location            = var.location
  tags                = var.tags

  network_interface_ids = [element(azurerm_network_interface.azp_agent_vm_nic.*.id, count.index)]
  vm_size               = var.size
  availability_set_id   = azurerm_availability_set.azp_availability_set.id

  delete_os_disk_on_termination    = var.delete_os_disk_on_termination
  delete_data_disks_on_termination = var.delete_data_disks_on_termination

  storage_image_reference {
    id        = lookup(var.storage_image_reference, "id", "")
    publisher = lookup(var.storage_image_reference, "publisher", "")
    offer     = lookup(var.storage_image_reference, "offer", "")
    sku       = lookup(var.storage_image_reference, "sku", "")
    version   = lookup(var.storage_image_reference, "version", "")
  }

  storage_os_disk {
    name              = "${format("${var.prefix}-%02d", count.index + 1)}-os"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = var.os_disk_storage_account_type
  }

  storage_data_disk {
    name            = element(azurerm_managed_disk.azp_agent_vm_disk.*.name, count.index)
    managed_disk_id = element(azurerm_managed_disk.azp_agent_vm_disk.*.id, count.index)
    create_option   = "Attach"
    lun             = 1
    disk_size_gb    = element(azurerm_managed_disk.azp_agent_vm_disk.*.disk_size_gb, count.index)
  }

  os_profile {
    computer_name  = format("${var.prefix}-%02d", count.index + 1)
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
    timezone                  = var.timezone
  }
}
