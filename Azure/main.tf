provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "myrg" {
  name     = "myResourceGroup"
  location = "East US"
}

resource "azurerm_virtual_network" "myvnet" {
  name                = "myVNet"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "web_subnet" {
  name                 = "webSubnet"
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "app_subnet" {
  name                 = "appSubnet"
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "public_ip" {
  name                = "myPublicIP"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "web_nic" {
  name                = "webNIC"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "webNICConfig"
    subnet_id                     = azurerm_subnet.web_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id           = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_network_interface" "app_nic" {
  name                = "appNIC"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "appNICConfig"
    subnet_id                     = azurerm_subnet.app_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_network_gateway" "gateway" {
  name                = "myVNGateway"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  type                = "Vpn"
  vpn_type            = "RouteBased"
  active_active       = false
  sku                 = "VpnGw1"
}

resource "azurerm_virtual_network_gateway_connection" "gateway_conn" {
  name                = "myGatewayConnection"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  virtual_network_gateway_id = azurerm_virtual_network_gateway.gateway.id
  local_network_gateway_id   = null
  connection_type            = "IPsec"
  routing_weight             = 10
  shared_key                 = "supersecretkey"
  enable_bgp                 = false
  local_network_gateway2_id  = null
}

resource "azurerm_linux_virtual_machine" "web_server" {
  name                = "webServer"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  admin_password      = "AdminP@ssw0rd1234"
  network_interface_ids = [azurerm_network_interface.web_nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "8_2"
    version   = "latest"
  }

  custom_data = <<-EOF
              #!/bin/bash
              sudo yum -y update
              sudo yum -y install httpd
              sudo systemctl start httpd
              sudo systemctl enable httpd
              echo "<html><h1>This is site on Web Server</h1></html>" | sudo tee /var/www/html/index.html
              EOF
}

resource "azurerm_linux_virtual_machine" "app_server" {
  name                = "appServer"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  admin_password      = "AdminP@ssw0rd1234"
  network_interface_ids = [azurerm_network_interface.app_nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "8_2"
    version   = "latest"
  }

  custom_data = <<-EOF
              #!/bin/bash
              sudo yum -y update
              sudo yum -y install httpd
              sudo systemctl start httpd
              sudo systemctl enable httpd
              echo "<html><h1>This is site on App Server</h1></html>" | sudo tee /var/www/html/index.html
              EOF
}

output "web_server_public_ip" {
  value = azurerm_public_ip.public_ip.ip_address
}

output "app_server_public_ip" {
  value = azurerm_network_interface.app_nic.0.ip_configuration.0.public_ip_address
}
