# Definir el proveedor de Azure
provider "azurerm" {
  features {}

  subscription_id = "bc9894f8-ffeb-4b69-831a-00ba29315716"
}

# Variable para definir la región de despliegue
variable "location" {
  description = "Ubicación de despliegue"
  default     = "East US"
}

# Crear un grupo de recursos
resource "azurerm_resource_group" "odoo_rg" {
  name     = "odoo-resource-group"
  location = var.location
}

# Crear una red virtual y una subred
resource "azurerm_virtual_network" "odoo_vnet" {
  name                = "odoo-vnet"
  location            = azurerm_resource_group.odoo_rg.location
  resource_group_name = azurerm_resource_group.odoo_rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "odoo_subnet" {
  name                 = "odoo-subnet"
  resource_group_name  = azurerm_resource_group.odoo_rg.name
  virtual_network_name = azurerm_virtual_network.odoo_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Crear una IP pública para la VM
resource "azurerm_public_ip" "odoo_ip" {
  name                = "odoo-public-ip"
  location            = azurerm_resource_group.odoo_rg.location
  resource_group_name = azurerm_resource_group.odoo_rg.name
  allocation_method   = "Static"
}

# Crear una interfaz de red para la VM
resource "azurerm_network_interface" "odoo_nic" {
  name                = "odoo-nic"
  location            = azurerm_resource_group.odoo_rg.location
  resource_group_name = azurerm_resource_group.odoo_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.odoo_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.odoo_ip.id
  }
}

# Crear un grupo de seguridad para permitir SSH
resource "azurerm_network_security_group" "odoo_nsg" {
  name                = "odoo-nsg"
  location            = azurerm_resource_group.odoo_rg.location
  resource_group_name = azurerm_resource_group.odoo_rg.name

  security_rule {
    name                       = "allow_ssh"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Crear una Máquina Virtual Ubuntu
resource "azurerm_linux_virtual_machine" "odoo_vm" {
  name                = "odoo-vm"
  resource_group_name = azurerm_resource_group.odoo_rg.name
  location            = azurerm_resource_group.odoo_rg.location
  size                = "Standard_B1s"
  admin_username      = "azureuser"

  network_interface_ids = [azurerm_network_interface.odoo_nic.id]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("C:/Users/Francisco Marchan/.ssh/id_rsa.pub")
  }

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
}

output "public_ip" {
  value = azurerm_public_ip.odoo_ip.ip_address
}
resource "azurerm_resource_group" "resource_g" {
  name     = "projectbittest"
  location = "East US"
}
resource "azurerm_resource_group" "rg_basic_vm" {
  name     = "rg-basic-vm"
  location = "East US"
}
