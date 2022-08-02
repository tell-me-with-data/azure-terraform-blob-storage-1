output "storages_accounts_outputs" {
  value = { for k, v in azurerm_storage_account.storage_accounts : k => v.name }
}

output "storages_containers_outputs" {
  value = { for k, v in azurerm_storage_container.storage_containers : k => v.name }
}

output "storages_blobs_outputs" {
  value = { for k, v in azurerm_storage_blob.storage_blobs : k => v.name }
}
