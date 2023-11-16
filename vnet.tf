resource "azurerm_virtual_network" "vnet" {
  name                = "vsad-${var.env}-${var.proj}-network"
  address_space       = var.vnet_address_space
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  tags                = merge(var.common_tags, var.extra_tags)
}

resource "azurerm_subnet" "fn-subnet-fa" {
  name                 = "vsad-${var.env}-${var.proj}-fn-subnet-fa"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.fn_sn_fa
  service_endpoints    = ["Microsoft.Sql", "Microsoft.Storage"]

  delegation {
    name = "fn-delegation-fa"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }

}

resource "azurerm_subnet" "pe-subnet-fa" {
  name                 = "vsad-${var.env}-${var.proj}-pe-fa-subnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.pe_fa_address_space
}

/*
resource "azurerm_subnet" "str-subnet" {
  name                 = "vsad-${var.env}-${var.proj}-str-subnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.str_address_space
}



# Private endpoint for main function app

resource "azurerm_private_endpoint" "pe-fa" {
  name                = "vsad-${var.env}-${var.proj}-fa-private-endpoint"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.pe-subnet-fa.id
  tags                = merge(var.common_tags, var.extra_tags)

  private_service_connection {
    name                           = "vsad-${var.env}-${var.proj}-fa-private-connection"
    private_connection_resource_id = azurerm_linux_function_app.fa.id
    is_manual_connection           = false
    subresource_names              = ["sites"]
  }
*/
/*
  private_dns_zone_group {
    name                 = "ingester-${var.env}-pvtdns"
    private_dns_zone_ids = [azurerm_private_dns_zone.apdz.id]
  }
  */
/*
  depends_on = [
    azurerm_linux_function_app.fa
  ]
}

# Private endpoint for storage
resource "azurerm_private_endpoint" "pe-str" {
  name                = "it-${var.env}-${var.proj}-str-private-endpoint"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.pe-subnet-fa.id
  tags                = merge(var.common_tags, var.extra_tags)

  private_service_connection {
    name                           = "vsad-${var.env}-${var.proj}-str-private-connection"
    private_connection_resource_id = azurerm_storage_account.sa.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
  */
/*
  private_dns_zone_group {
    name                 = "str-${var.env}-pvtdns"
    private_dns_zone_ids = [azurerm_private_dns_zone.apdz.id]
  }
  */
/*
  depends_on = [
    azurerm_storage_account.sa
  ]
}


# private DNS for storage
resource "azurerm_private_dns_zone" "apdz-str" {
  name                = "blob.core.windows.net"
  resource_group_name = data.azurerm_resource_group.rg.name
  tags                = merge(var.common_tags, var.extra_tags)
}

resource "azurerm_private_dns_zone_virtual_network_link" "apdz-vl-str" {
  name                  = "vsad-${var.env}-${lower(var.proj)}-dns-vl-str"
  resource_group_name   = data.azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.apdz-str.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  tags                  = merge(var.common_tags, var.extra_tags)
}

resource "azurerm_private_dns_a_record" "apdar-str" {
  name                = azurerm_storage_account.sa.name
  zone_name           = azurerm_private_dns_zone.apdz-str.name
  resource_group_name = data.azurerm_resource_group.rg.name
  ttl                 = 60
  records             = [azurerm_private_endpoint.pe-str.custom_dns_configs[0].ip_addresses[0]]
}

# private DNS for function
resource "azurerm_private_dns_zone" "apdz-fa" {
  name                = "azurewebsites.net"
  resource_group_name = data.azurerm_resource_group.rg.name
  tags                = merge(var.common_tags, var.extra_tags)
}

resource "azurerm_private_dns_zone_virtual_network_link" "apdz-vl-fa" {
  name                  = "vsad-${var.env}-${lower(var.proj)}-dns-vl-fa"
  resource_group_name   = data.azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.apdz-fa.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  tags                  = merge(var.common_tags, var.extra_tags)
}
resource "azurerm_private_dns_a_record" "apdar-ingester" {
  name                = lower(azurerm_linux_function_app.fa.name)
  zone_name           = azurerm_private_dns_zone.apdz-fa.name
  resource_group_name = data.azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.pe-fa.custom_dns_configs[0].ip_addresses[0]]
}
*/