# azp-build-agent-windows-vm

This repository contains Terraform code to deploy [Windows virtual machines as self-hosted build agents for Azure Pipelines](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/v2-windows?view=azure-devops).

Actually there is no _ready to use_ virtual machine extension for **build agents**. The only [existing extension is for deployment agents](https://docs.microsoft.com/en-us/azure/devops/pipelines/release/deployment-groups/howto-provision-deployment-group-agents?view=azure-devops#install-the-azure-pipelines-agent-azure-vm-extension-using-an-arm-template).

Essentially we use a [_Custom Script Extension_](https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-windows) to install an Azure Pipelines Agent with a powershell script.

## Overview

```bash
├── README.md                       # this file
├── modules                         # Terraform modules
│   ├── resource-group              # creates a resource group
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── private-network             # creates a private virtual network with a subnet
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── virtual-machine             # creates one or more virtual machines and it's data disks
│   |   ├── main.tf
│   |   ├── outputs.tf
│   |   └── variables.tf
│   └── azp-agent-extension         # contains custom script extension to install agent
│       ├── main.tf
│       └── variables.tf
├── examples                        # example code to provide 2 virtual machines as build agents for your Azure Pipelines account
│   └── azp_agent_vm
│       ├── main.tf
│       └── variables.tf
├── install-azp-agent.ps1           # agent download and install instructions (referred from custom script extensions)
├── envrc.template                  # example environment configuration
├── tf-run.sh                       # playbook for dockerized terraform runs
├── sh-check.sh                     # checks all *.sh scripts in this repository
├── tf-validate.sh                  # validates all Terraform code in this repository
└── LICENSE

```

## Features

There are a few inspiring options in the wild which have been merged in this solution:

- concerns are separated to Terraform modules and you can easily integrate with other modules
- uses [latest stable or prerelease version of Azure Pipelines Agent directly from github](https://github.com/Microsoft/azure-pipelines-agent)
- agent installation path and work directory can be configured
- data disks and it's preparation are supported
- quantity of virtual machines can be configured
- custom images are supported

## Limitations

We use a _Custom Script Extension_ to install an agent but you can only have **ONE** of it for a virtual machine. If you plan to install some other stuff with a custom script extension, such as Chocolatey packages, you might need another solution (eg. [packer](https://www.packer.io/)-made images with preconfigured build environment for your purposes).

## Getting started

### Prerequisites

- Unix like operation system or WSL on Windows
- [Docker installed](https://docs.docker.com/install/)

### Environment Configuration

| Environment variable | Purpose |
|---|---|
| ARM_CLIENT_ID | Azure Service Principal Credentials for [Terraform AzureRM Provider](https://www.terraform.io/docs/providers/azurerm/guides/service_principal_client_secret.html) |
| ARM_CLIENT_SECRET | Azure Service Principal Credentials for [Terraform AzureRM Provider](https://www.terraform.io/docs/providers/azurerm/guides/service_principal_client_secret.html) |
| ARM_SUBSCRIPTION_ID | Azure Subscription for [Terraform AzureRM Provider](https://www.terraform.io/docs/providers/azurerm/guides/service_principal_client_secret.html) |
| ARM_TENANT_ID | Azure Tenant for [Terraform AzureRM Provider](https://www.terraform.io/docs/providers/azurerm/guides/service_principal_client_secret.html) |
| AZP_ACCOUNT | Azure Pipelines Account (eg. https://dev.azure.com/{your-account-name}) |
| AZP_PERSONAL_ACCESS_TOKEN | Personal Access Token to register agent |
| VM_ADMIN_PASSWORD | Password for virtual machine's local administation account |

In local environment you can use [**direnv**](https://direnv.net/) to _unclutter your profile_. Simply copy `envrc.template` to `.envrc`, reconfigure it and run `direnv allow` to set up your local environment.

### Terraforming

```bash
# Usage: tf-run.sh <plan|apply|destroy> <module>
bash tf-run.sh plan examples/azp_agent_vm
bash tf-run.sh apply examples/azp_agent_vm
```
