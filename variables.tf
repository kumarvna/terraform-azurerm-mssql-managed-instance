variable "create_resource_group" {
  description = "Whether to create resource group and use it for all networking resources"
  type        = bool
  default     = true
}

variable "resource_group_name" {
  description = "A container that holds related resources for an Azure solution"
  default     = ""
}

variable "location" {
  description = "The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
  default     = ""
}

variable "random_password_length" {
  description = "The desired length of random password created by this module"
  default     = 32
}

variable "managed_instance_name" {
  description = " The name of the SQL Managed Instance. This needs to be globally unique within Azure."
  default     = ""
}

variable "license_type" {
  description = "What type of license the Managed Instance will use. Valid values include can be `PriceIncluded` or `BasePrice`"
  default     = "BasePrice"
}

variable "sku_name" {
  description = "Specifies the SKU Name for the SQL Managed Instance. Valid values include `GP_Gen4`, `GP_Gen5`, `GP_G8IM`, `GP_G8IH`, `BC_Gen4`, `BC_Gen5`, `BC_G8IM` or `BC_G8IH`."
  default     = "GP_Gen5"
}

variable "number_of_vcores" {
  description = "Number of cores that should be assigned to the SQL Managed Instance. Values can be `8`, `16`, or `24` for `Gen4` SKUs, or `8`, `16`, `24`, `32`, or `40` for `Gen5` SKUs."
  default     = "4"
}

variable "storage_size_in_gb" {
  description = "Maximum storage space for the SQL Managed instance. This should be a multiple of 32 (GB)."
  default     = "32"
}

variable "storage_account_type" {
  description = "Specifies the storage account type used to store backups for this database. Possible values are `GRS`, `LRS` and `ZRS`"
  default     = "GRS"
}

variable "admin_username" {
  description = "The administrator login name for the new SQL Server"
  default     = null
}

variable "admin_password" {
  description = "The password associated with the admin_username user"
  default     = null
}

variable "subnet_id" {
  description = "The subnet resource id that the SQL Managed Instance will be associated with."
  default     = ""
}

variable "collation" {
  description = "Specifies how the SQL Managed Instance will be collated."
  default     = "SQL_Latin1_General_CP1_CI_AS"
}

variable "minimum_tls_version" {
  description = "The Minimum TLS Version for all SQL Database and SQL Data Warehouse databases associated with the server. Valid values are: `1.0`, `1.1` and `1.2`."
  default     = null
}

variable "dns_zone_partner_id" {
  description = "The ID of the SQL Managed Instance which will share the DNS zone. This is a prerequisite for creating an `azurerm_managed_instance_failover_group`. Setting this after creation forces a new resource to be created."
  default     = null
}

variable "proxy_override" {
  description = "Specifies how the SQL Managed Instance will be accessed. Valid values include `Default`, `Proxy`, and `Redirect`."
  default     = "Default"
}

variable "enable_public_data_endpoint" {
  description = "Is the public data endpoint enabled?"
  default     = false
}

variable "timezone_id" {
  description = "The TimeZone ID that the SQL Managed Instance will be operating in."
  default     = "UTC"
}

variable "enable_system_assigned_identiy" {
  description = "Enable system assigned identity for the SQL Managed Instance."
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
