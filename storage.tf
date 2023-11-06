# Storage Account
resource "azurerm_storage_account" "sa" {
  name                     = "vsad${var.env}${lower(var.str_name)}"
  location                 = data.azurerm_resource_group.rg.location
  resource_group_name      = data.azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = var.storage_account_replication_type
  min_tls_version          = "TLS1_2"
  tags                     = merge(var.common_tags, var.extra_tags)

  /*
  network_rules {
    default_action = "Deny"
    # bypass         = ["AzureServices"]
    ip_rules = [azurerm_windows_function_app.fa.possible_outbound_ip_addresses]
  }
  */
}

# Create a list of IP rules based on the outbound IP addresses
resource "azurerm_storage_account_network_rules" "asanr" {
  storage_account_id = azurerm_storage_account.sa.id

  default_action             = "Allow"
  virtual_network_subnet_ids = [azurerm_subnet.fn-subnet-fa.id]
  # ip_rules       = concat(azurerm_windows_function_app.fa.possible_outbound_ip_address_list, var.az_devops_ip)
  # bypass = ["Metrics"]
  bypass = ["AzureServices"]
}

# Private container within above storage account (multipurpose - for JSON, images, thumbnails)
resource "azurerm_storage_container" "secure" {
  name                  = "vsad-${var.env}-${lower(var.proj)}-asc"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}