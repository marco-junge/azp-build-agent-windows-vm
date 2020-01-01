variable "resource_group_name" {
  type        = string
  description = "Resource group name"
  default     = "rg-azp-agents"
}

variable "location" {
  type        = string
  description = "Location for azure resource"
  default     = "westeurope"
}

variable "tags" {
  type        = map(string)
  description = "Azure resource tags."
  default = {
    stage       = "dev"
    system      = "Azure Pipelines"
    description = "Self hosted agents for Azure Pipelines."
  }
}

variable "vnet_name" {
  type        = string
  description = "Virtual network name."
  default     = "azp-agents-net"
}

variable "vnet_address_space" {
  type = list(string)
  description = "Address space for virtual network."
  default = ["10.0.0.0/16"]
}

variable "subnet_name" {
  type        = string
  description = "Subnet's name."
  default     = "azp-agents-subnet"
}

variable "subnet_address_prefix" {
  type        = string
  description = "Address prefix for subnet."
  default     = "10.0.2.0/24"
}

variable "availability_set_name" {
  type        = string
  description = "Availability set name in which virtual machine should exist."
  default     = "av-set-azpagents"
}

variable "vm_quantity" {
  description = "Quantity of virtual machines"
  default     = 1
}

variable "vm_prefix" {
  type        = string
  description = "Prefix for virtual machine name"
  default     = "azpagent"
}

variable "vm_storage_image_reference" {
  type        = map(string)
  description = "Specifies virtual machine image (standard or custom)."
  default     = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

variable "vm_admin_username" {
  type        = string
  description = "Admin username of virtual machine."
  default     = "local-azp-admin"
}

variable "vm_admin_password" {
  type        = string
  description = "Admin password of virtual machine."
}

variable "vm_size" {
  type        = string
  description = "Virtual machine's SKU (e.g. Standard_DS1_v2)"
  default     = "Standard_B2_ms"
}

variable "vm_delete_os_disk_on_termination" {
  type        = bool
  description = "Deletes os disk on termination if 'true'."
  default     = true
}

variable "vm_delete_data_disks_on_termination" {
  type        = bool
  description = "Deletes data disk on termination if 'true'."
  default     = true
}

variable "vm_data_disk_size_gb" {
  type        = number
  description = "Data disk size in gigabytes. Default is 100 GB."
  default     = 100
}
