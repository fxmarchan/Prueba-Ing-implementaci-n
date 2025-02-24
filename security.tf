resource "azurerm_network_security_group" "nsg_basic" {
  name                = "nsg-basic"
  location            = azurerm_resource_group.rg_basic_vm.location
  resource_group_name = azurerm_resource_group.rg_basic_vm.name
}

resource "azurerm_network_security_rule" "allow_ssh" {
  name                        = "allow_ssh"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg_basic_vm.name
  network_security_group_name = azurerm_network_security_group.nsg_basic.name
}

resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  subnet_id                 = azurerm_subnet.subnet_basic.id
  network_security_group_id = azurerm_network_security_group.nsg_basic.id
}
