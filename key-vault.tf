resource "azurerm_key_vault_access_policy" "keyvault_policy_cms" {
  key_vault_id = data.azurerm_key_vault.vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_linux_function_app.fa.identity[0].principal_id
  secret_permissions = [
    "Get"
  ]
}

data "azurerm_key_vault_secret" "azure-tenant-id" {
  name         = "azure-tenant-id"
  key_vault_id = data.azurerm_key_vault.vault.id
}

data "azurerm_key_vault_secret" "defender-app-id" {
  name         = "defender-app-id"
  key_vault_id = data.azurerm_key_vault.vault.id
}

data "azurerm_key_vault_secret" "sumo-collector-url" {
  name         = "sumo-collector-url"
  key_vault_id = data.azurerm_key_vault.vault.id
}

data "azurerm_key_vault_secret" "comm-service-conn-string" {
  name = "comm-service-conn-string"
  # Azure communication services connection string
  key_vault_id = data.azurerm_key_vault.vault.id
}


