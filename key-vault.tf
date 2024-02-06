

resource "azurerm_key_vault_access_policy" "keyvault_policy_cms" {
  key_vault_id = data.azurerm_key_vault.vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_linux_function_app.fa.identity[0].principal_id
  secret_permissions = [
    "Get"
  ]
}

/*
resource "azurerm_role_assignment" "kv" {
  scope                = data.azurerm_key_vault.vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_linux_function_app.fa.identity[0].principal_id
  depends_on           = [azurerm_linux_function_app.fa]
}

*/

data "azurerm_key_vault_secret" "azure_tenant_id" {
  name         = "azure-tenant-id"
  key_vault_id = data.azurerm_key_vault.vault.id
}

data "azurerm_key_vault_secret" "defender_app_id" {
  name         = "defender-app-id"
  key_vault_id = data.azurerm_key_vault.vault.id
}

data "azurerm_key_vault_secret" "defender_app_secret" {
  name         = "defender-app-secret"
  key_vault_id = data.azurerm_key_vault.vault.id
}
data "azurerm_key_vault_secret" "sumo_collector_url" {
  name         = "sumo-collector-url"
  key_vault_id = data.azurerm_key_vault.vault.id
}

data "azurerm_key_vault_secret" "comm_service_conn_string" {
  name = "comm-service-conn-string"
  # Azure communication services connection string
  key_vault_id = data.azurerm_key_vault.vault.id
}

data "azurerm_key_vault_secret" "sharepoint_url" {
  name         = "sharepoint-url"
  key_vault_id = data.azurerm_key_vault.vault.id
}

data "azurerm_key_vault_secret" "sharepoint_dir" {
  name         = "sharepoint-dir"
  key_vault_id = data.azurerm_key_vault.vault.id
}

data "azurerm_key_vault_secret" "sharepoint_file_path" {
  name         = "sharepoint-file-path"
  key_vault_id = data.azurerm_key_vault.vault.id
}

data "azurerm_key_vault_secret" "cert_name" {
  name         = "cert-name"
  key_vault_id = data.azurerm_key_vault.vault.id
}


