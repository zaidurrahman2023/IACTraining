resource "azurerm_virtual_machine" "vm" {
  name                  = "vm-${azurerm_resource_group.example.name}"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  vm_size               = var.vm_size
  network_interface_ids = [azurerm_network_interface.nic.id]
  storage_os_disk {
    name          = "osdisk-${azurerm_resource_group.example.name}"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  os_profile {
    computer_name  = "vm-${azurerm_resource_group.example.name}"
    admin_username = var.vm_admin_username
    admin_password = var.vm_admin_password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}


