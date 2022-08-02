# Configuration for Terraform
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm",
      version = "~>2.38.0"
    }
  }
}

# Configuration for Azure Terraform Provider
provider "azurerm" {
  features {

  }
}

#Using data to fetch information about resources groups

data "azurerm_resource_group" "resources_groups" {
  for_each = var.enviroments
  name     = "${var.resource_prefix}-sales-${each.key}"
}

resource "azurerm_storage_account" "storage_accounts" {
  for_each                 = data.azurerm_resource_group.resources_groups
  name                     = "${var.storage_account_prefix}${each.key}"
  resource_group_name      = each.value.name
  location                 = each.value.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "storage_containers" {
  for_each              = azurerm_storage_account.storage_accounts
  name                  = "${var.storage_container_prefix}-${each.key}"
  storage_account_name  = each.value.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "storage_blobs" {
  for_each               = azurerm_storage_container.storage_containers
  name                   = "${var.storage_blob_prefix}-${each.key}"
  storage_account_name   = azurerm_storage_account.storage_accounts[each.key].name
  storage_container_name = each.value.name
  type                   = "Block"
}
