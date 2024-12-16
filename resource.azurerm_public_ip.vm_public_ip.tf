resource "azurerm_public_ip" "vm_public_ip" {
  name                = "public-ip-${azurerm_resource_group.example.name}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Static"
}

