variable "virtual_machine" {
  type        = string
  description = "Virtual network name."
}

variable "resource_group" {
  type        = string
  description = "Name of resource group."
}

variable "location" {
  type        = string
  description = "Location for azure resource."
}

variable "tags" {
  type        = map(string)
  description = "Virtual machine extension's resource tags."
  default     = {}
}

variable "azp_account" {
  type        = string
  description = "Azure Pipelines account name (e.g. from http://dev.azure.com/<account name>)."
}

variable "personal_access_token" {
  type        = string
  description = "Personal Access Token to join Azure Pipelines agent pool."
}

variable "pool_name" {
  type        = string
  description = "Azure Pipelines agent pool name (default is 'Default')."
  default     = "Default"
}

variable "agent_installation_path" {
  type        = string
  description = "Install path for agent on virtual machine."
  default     = "C:\\Azure-Pipelines-Agent"
}

variable "agent_work_path" {
  type        = string
  description = "Working directory for agent builds on virtual machine."
  default     = "C:\\Azure-Pipelines-Agent\\_work"
}

variable "pre_release" {
  type        = bool
  description = "Respects pre release versions for Azure Pipelines agent downloads."
  default     = false
}
