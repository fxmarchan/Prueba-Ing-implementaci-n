resource "azurerm_virtual_network" "vnet_basic" {
  name                = "vnet-basic"
  location            = azurerm_resource_group.rg_basic_vm.location
  resource_group_name = azurerm_resource_group.rg_basic_vm.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet_basic" {
  name                 = "subnet-basic"
  resource_group_name  = azurerm_resource_group.rg_basic_vm.name
  virtual_network_name = azurerm_virtual_network.vnet_basic.name
  address_prefixes     = ["10.0.1.0/24"]
}
