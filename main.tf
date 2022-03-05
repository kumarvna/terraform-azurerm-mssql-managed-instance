locals {
  resource_group_name = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, azurerm_resource_group.rg.*.name, [""]), 0)
  location            = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, azurerm_resource_group.rg.*.location, [""]), 0)
  #  if_threat_detection_policy_enabled = var.enable_threat_detection_policy ? [{}] : []
}

#---------------------------------------------------------
# Resource Group Creation or selection - Default is "false"
#----------------------------------------------------------

data "azurerm_resource_group" "rgrp" {
  count = var.create_resource_group ? 0 : 1
  name  = var.resource_group_name
}

resource "azurerm_resource_group" "rg" {
  count    = var.create_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = var.location
  tags     = merge({ "Name" = format("%s", var.resource_group_name) }, var.tags, )
}


#-------------------------------------------------------------------------
# SQL Managed Instances - Secondary server is depends_on Failover Group
#-------------------------------------------------------------------------

resource "random_password" "main" {
  length      = var.random_password_length
  min_upper   = 4
  min_lower   = 2
  min_numeric = 4
  special     = false

  keepers = {
    administrator_login_password = var.managed_instance_name
  }
}

resource "azurerm_mssql_managed_instance" "name" {
  name                         = lower(var.managed_instance_name)
  resource_group_name          = local.resource_group_name
  location                     = local.location
  license_type                 = var.license_type
  sku_name                     = var.sku_name
  vcores                       = var.number_of_vcores
  storage_size_in_gb           = var.storage_size_in_gb
  storage_account_type         = var.storage_account_type
  administrator_login          = var.admin_username == null ? "sqladmin" : var.admin_username
  administrator_login_password = var.admin_password == null ? random_password.main.result : var.admin_password
  subnet_id                    = var.subnet_id
  collation                    = var.collation
  minimum_tls_version          = var.minimum_tls_version
  dns_zone_partner_id          = var.dns_zone_partner_id
  proxy_override               = var.proxy_override
  public_data_endpoint_enabled = var.enable_public_data_endpoint
  timezone_id                  = var.timezone_id

  dynamic "identity" {
    for_each = var.enable_system_assigned_identiy != null ? [1] : []
    content {
      type = "SystemAssigned"
    }
  }
}


