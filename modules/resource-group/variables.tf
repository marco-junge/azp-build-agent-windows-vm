variable "name" {
  type        = string
  description = "Resource group's name."
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
