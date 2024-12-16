resource "azurerm_network_security_group" "vm_nsg" {
  name                = "nsg-${azurerm_resource_group.example.name}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  security_rule {
    name                         = "SSH"
    priority                     = 1001
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = "22"
    source_address_prefixes      = ["0.0.0.0/0"]
    destination_address_prefixes = ["0.0.0.0/0"]
  }
}


