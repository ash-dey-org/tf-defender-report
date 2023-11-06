data "azurerm_resource_group" "rg" {
  name = "${var.env}-${var.region}-${var.company}-rg-${var.proj}"
}


data "azurerm_key_vault" "vault" {
  name                = "${var.env}-${var.region}-${var.company}-kv-${var.kvname}"
  resource_group_name = "${var.env}-${var.region}-${var.company}-rg-${var.proj}"
}

data "azurerm_client_config" "current" {}


# Service Plan
resource "azurerm_service_plan" "sp" {
  name                = "vsad-${var.env}-${var.proj}-asp"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = var.service_plan_sku
  tags                = merge(var.common_tags, var.extra_tags)
}

# App Insights
resource "azurerm_application_insights" "insights" {
  name                = "vsad-${var.env}-${var.proj}-aai"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  application_type    = "web"
  tags                = merge(var.common_tags, var.extra_tags)
}


# Function App (what will actually hold our code)
resource "azurerm_linux_function_app" "fa" {
  name                = "vsad-${var.env}-${var.proj}-alfa"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  https_only          = true

  storage_account_name       = azurerm_storage_account.sa.name
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key

  service_plan_id = azurerm_service_plan.sp.id
  tags            = merge(var.common_tags, var.extra_tags)

  identity {
    type = "SystemAssigned"
  }

  virtual_network_subnet_id = azurerm_subnet.fn-subnet-fa.id

  # depends_on = [ azurerm_windows_function_app.azurerm_windows_function_app.ingester_app ]

  app_settings = {

    azure-tenant-id          = "@Microsoft.KeyVault(SecretUri=${data.azurerm_key_vault_secret.azure-tenant-id.versionless_id})"
    defender-app-id          = "@Microsoft.KeyVault(SecretUri=${data.azurerm_key_vault_secret.defender-app-id.versionless_id})"
    sumo-collector-url       = "@Microsoft.KeyVault(SecretUri=${data.azurerm_key_vault_secret.sumo-collector-url.versionless_id})"
    comm-service-conn-string = "@Microsoft.KeyVault(SecretUri=${data.azurerm_key_vault_secret.comm-service-conn-string.versionless_id})"

  }

  site_config {

    application_insights_key               = azurerm_application_insights.insights.instrumentation_key
    application_insights_connection_string = azurerm_application_insights.insights.connection_string
    # always_on                              = true
    application_stack {
      python_version = "3.10"
    }
    /*
    cors {
      allowed_origins     = ["https://${lower(azurerm_linux_web_app.cms.name)}.${var.custom_domain_host}"]
      support_credentials = false
    }

    # vnet_route_all_enabled = true

    ip_restriction {
      name        = "azure-front-door-restriction"
      priority    = 100
      service_tag = "AzureFrontDoor.Backend"
      headers {
        x_azure_fdid = [azurerm_cdn_frontdoor_profile.fp.resource_guid]

      }

      action = "Allow"
    }
*/
    dynamic "ip_restriction" {
      for_each = var.az_devops_ip
      content {
        name       = "allow az devops IP"
        priority   = 100
        action     = "Allow"
        ip_address = ip_restriction.value
      }
    }

  }

  lifecycle {
    ignore_changes = [
      app_settings["WEBSITE_ENABLE_SYNC_UPDATE_SITE"],
      app_settings["WEBSITE_RUN_FROM_PACKAGE"],
      tags
    ]
  }

}