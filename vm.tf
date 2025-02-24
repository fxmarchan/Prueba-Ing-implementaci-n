resource "azurerm_network_interface" "nic_basic" {
  name                = "nic-basic"
  location            = azurerm_resource_group.rg_basic_vm.location
  resource_group_name = azurerm_resource_group.rg_basic_vm.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_basic.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip_vm.id
  }
}

resource "azurerm_public_ip" "public_ip_vm" {
  name                = "public-ip-vm"
  location            = azurerm_resource_group.rg_basic_vm.location
  resource_group_name = azurerm_resource_group.rg_basic_vm.name
  allocation_method   = "Static"
}

resource "azurerm_linux_virtual_machine" "vm_basic" {
  name                  = "basic-vm"
  location              = azurerm_resource_group.rg_basic_vm.location
  resource_group_name   = azurerm_resource_group.rg_basic_vm.name
  network_interface_ids = [azurerm_network_interface.nic_basic.id]
  size                  = "Standard_B1s"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "basic-vm"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub") # Asegúrate de que este archivo existe
  }

  depends_on = [azurerm_network_interface.nic_basic]
}
