variable "virtual_machine_name" {
  type = string
}

variable "resource_group" {
  type = string
}

variable "location" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "azp_account" {
  type = string
}

variable "personal_access_token" {
  type = string
}

variable "pool_name" {
  type    = string
  default = "Default"
}

variable "agent_installation_path" {
  type    = string
  default = "C:\\Azure-Pipelines-Agent"
}

variable "agent_work_path" {
  type    = string
  default = "C:\\Azure-Pipelines-Agent\\_work"
}

variable "pre_release" {
  type    = bool
  default = false
}
