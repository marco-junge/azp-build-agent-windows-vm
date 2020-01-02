module "azp_group" {
  source   = "../../modules/resource-group"
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

module "azp_network" {
  source                = "../../modules/private-network"
  name                  = var.vnet_name
  resource_group        = module.azp_group.name
  location              = module.azp_group.location
  tags                  = module.azp_group.tags
  address_space         = var.vnet_address_space
  subnet_name           = var.subnet_name
  subnet_address_prefix = var.subnet_address_prefix
}

module "azp_virtual_machine" {
  source                           = "../../modules/virtual-machine"
  resource_group                   = module.azp_group.name
  location                         = module.azp_group.location
  tags                             = module.azp_group.tags
  prefix                           = var.vm_prefix
  quantity                         = var.vm_quantity
  availability_set_name            = var.availability_set_name
  admin_username                   = var.vm_admin_username
  admin_password                   = var.vm_admin_password
  size                             = var.vm_size
  storage_image_reference          = var.vm_storage_image_reference
  delete_os_disk_on_termination    = var.vm_delete_os_disk_on_termination
  delete_data_disks_on_termination = var.vm_delete_data_disks_on_termination
  data_disk_size_gb                = var.vm_data_disk_size_gb
  subnet_id                        = module.azp_network.subnet.id
}

module "azp_agent_extension" {
  source                  = "../../modules/azp-agent-extension"
  virtual_machine         = module.azp_virtual_machine.name
  resource_group          = module.azp_group.name
  location                = module.azp_group.location
  tags                    = module.azp_group.tags
  azp_account             = var.azp_account
  personal_access_token   = var.azp_personal_access_token
  pool_name               = var.azp_pool_name
  agent_installation_path = var.azp_agent_installation_path
  agent_work_path         = var.azp_agent_work_path
}
