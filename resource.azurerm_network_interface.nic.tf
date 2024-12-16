resource "azurerm_network_interface" "nic" {
  name                = "nic-${azurerm_resource_group.example.name}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  ip_configuration {
    name                          = "ipconfig-${azurerm_resource_group.example.name}"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}