variable "resource_group" {
  type        = string
  description = "Resource group name."
}

variable "location" {
  type        = string
  description = "Location for azure resource."
}

variable "tags" {
  type        = map(string)
  description = "Virtual machine's resource tags."
  default     = {}
}

variable "quantity" {
  description = "Quantity of virtual machines."
  default     = 1
}

variable "availability_set_name" {
  description = "Availability set name in which virtual machine should exist."
}

variable "prefix" {
  type        = string
  description = "Prefix for virtual machine name"
}

variable "storage_image_reference" {
  type        = map(string)
  description = "Specifies virtual machine image (standard or custom)."
  default = {
    id        = ""
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

variable "admin_username" {
  type        = string
  description = "Admin username of virtual machine."
}

variable "admin_password" {
  type        = string
  description = "Admin password of virtual machine."
}

variable "size" {
  type        = string
  description = "Virtual machine's SKU (e.g. Standard_DS1_v2)"
}

variable "delete_os_disk_on_termination" {
  type        = bool
  description = "Deletes os disk on termination if 'true'."
}

variable "delete_data_disks_on_termination" {
  type        = bool
  description = "Deletes data disk on termination if 'true'."
}

variable "data_disk_size_gb" {
  type        = number
  description = "Data disk size in gigabytes."
}

variable "data_disk_storage_account_type" {
  type        = string
  description = "Virtual machine's data disk storage account type (default 'Standard_LRS')"
  default     = "Standard_LRS"
}

variable "os_disk_storage_account_type" {
  type        = string
  description = "Virtual machine's os disk storage account type (default 'Standard_LRS')"
  default     = "Standard_LRS"
}

variable "timezone" {
  type        = string
  description = "Timezone for your virtual machine."
  default     = "W. Europe Standard Time"
}

variable "subnet_id" {
  type        = string
  description = "Resource identifier for subnet in which virtual machine should exist."
}
