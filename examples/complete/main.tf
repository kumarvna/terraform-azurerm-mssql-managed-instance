# Azurerm provider configuration
provider "azurerm" {
  features {}
}

module "vnet" {
  source  = "kumarvna/vnet/azurerm"
  version = "2.2.0"

  resource_group_name    = "rg-shared-westeurope-02"
  vnetwork_name          = "vnet-shared-hub-westeurope-002"
  location               = "westeurope"
  vnet_address_space     = ["10.1.0.0/16"]
  create_network_watcher = false

  subnets = {
    mgnt_subnet = {
      subnet_name           = "snet-midatabase"
      subnet_address_prefix = ["10.1.0.0/24"]
      delegation = {
        name = "managedinstancedelegation"
        service_delegation = {
          name    = "Microsoft.Sql/managedInstances"
          actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action", "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"]
        }
      }

      nsg_inbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
        # To use defaults, use "" without adding any values.
        ["allow_management_inbound1", "100", "Inbound", "Allow", "Tcp", "9000", "*", "*"],
        ["allow_management_inbound2", "101", "Inbound", "Allow", "Tcp", "9003", "*", "*"],
        ["allow_management_inbound3", "102", "Inbound", "Allow", "Tcp", "1438", "*", "*"],
        ["allow_management_inbound4", "103", "Inbound", "Allow", "Tcp", "1440", "*", "*"],
        ["allow_management_inbound5", "104", "Inbound", "Allow", "Tcp", "1452", "*", "*"],
        ["allow_misubnet_inbound", "200", "Inbound", "Allow", "*", "*", "10.1.0.0/24", "*"],
        ["allow_health_probe_inbound", "300", "Inbound", "Allow", "*", "*", "AzureLoadBalancer", "*"],
        ["allow_tds_inbound", "400", "Inbound", "Allow", "*", "1433", "VirtualNetwork", "*"],
      ]

      nsg_outbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
        # To use defaults, use "" without adding any values.
        ["allow_management_outbound1", "100", "Outbound", "Allow", "Tcp", "80", "*", "*"],
        ["allow_management_outbound2", "101", "Outbound", "Allow", "Tcp", "443", "*", "*"],
        ["allow_management_outbound3", "102", "Outbound", "Allow", "Tcp", "12000", "*", "*"],
        ["allow_misubnet_outbound", "202", "Outbound", "Allow", "*", "*", "10.1.0.0/24", "*"],
      ]
    }
  }

  # Adding TAG's to your Azure resources (Required)
  tags = {
    ProjectName  = "demo-internal"
    Env          = "dev"
    Owner        = "user@example.com"
    BusinessUnit = "CORP"
    ServiceClass = "Gold"
  }
}


module "mssql-managed-instance" {
  // source  = "kumarvna/mssql-managed-instance/azurerm"
  // version = "1.0.0"
  source = "../../"

  # By default, this module will create a resource group
  # proivde a name to use an existing resource group and set the argument 
  # to `create_resource_group = false` if you want to existing resoruce group. 
  # If you use existing resrouce group location will be the same as existing RG.
  create_resource_group = false
  resource_group_name   = module.vnet.resource_group_name
  location              = module.vnet.resource_group_location

  # SQL Managed Instance and Database details
  managed_instance_name = "mi-sqldbserver01"
  sku_name              = "GP_Gen5"
  number_of_vcores      = 4
  storage_size_in_gb    = 32
  subnet_id             = element(module.vnet.subnet_ids, 0)

  depends_on = [
    module.vnet
  ]
}
