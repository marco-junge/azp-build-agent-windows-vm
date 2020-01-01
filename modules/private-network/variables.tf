variable "name" {
  type        = string
  description = "Virtual network name."
}

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
  description = "Virtual network's resource tags."
  default     = {}
}

variable "address_space" {
  type = list(string)
  description = "Address space for virtual network."
}

variable "subnet_name" {
  type        = string
  description = "Subnet's name."
}

variable "subnet_address_prefix" {
  type        = string
  description = "Address prefix for subnet."
}
