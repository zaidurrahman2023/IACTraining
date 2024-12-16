# create a subnet in the VNET
resource "azurerm_subnet" "subnet" {
  name                 = "subnet-${var.resource_group_name}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = ["10.0.0.0/24"]
}

