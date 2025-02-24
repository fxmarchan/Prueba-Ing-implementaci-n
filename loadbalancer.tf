resource "azurerm_public_ip" "lb_public_ip" {
  name                = "lb-public-ip"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.resource_g.name
  sku                 = "Standard"
  allocation_method   = "Static"

  depends_on = [azurerm_resource_group.resource_g]
}
resource "azurerm_lb" "odoo_lb" {
  name                = "odoo-loadbalancer"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "public-ip"
    public_ip_address_id = azurerm_public_ip.lb_public_ip.id
  }
}
resource "azurerm_lb_backend_address_pool" "backend_pool" {
  name            = "odoo-backend-pool"
  loadbalancer_id = azurerm_lb.odoo_lb.id
}
resource "azurerm_lb_rule" "http_rule" {
  name                           = "http-rule"
  loadbalancer_id                = azurerm_lb.odoo_lb.id
  frontend_ip_configuration_name = "public-ip"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool.id]
}
resource "azurerm_network_interface_backend_address_pool_association" "odoo_lb_assoc" {
  network_interface_id    = azurerm_network_interface.odoo_nic.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool.id # CAMBIAR A "backend_address_pool_id"
}
