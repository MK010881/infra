resource "azurerm_resource_group" "testrg" {
  name     = var.infra-config.resource_group_name
  location = var.infra-config.resource_group_location
}

resource "azurerm_storage_account" "teststg" {
  name                     = var.infra-config.storage_account
  location                 = var.infra-config.resource_group_location
  resource_group_name      = var.infra-config.resource_group_name
  account_tier             = var.infra-config.account_tier
  account_replication_type = var.infra-config.account_replication_type
}

resource "azurerm_virtual_network" "testvnet" {
  name                = var.infra-config.vnet_name
  location            = var.infra-config.resource_group_location
  resource_group_name = var.infra-config.resource_group_name
  address_space       = var.infra-config.address_space
}

resource "azurerm_subnet" "testsubnet" {
  depends_on           = [azurerm_virtual_network.testvnet]
  name                 = var.infra-config.subnet_name
  resource_group_name  = var.infra-config.resource_group_name
  virtual_network_name = var.infra-config.vnet_name
  address_prefixes     = var.infra-config.address_prefixes
}

resource "azurerm_network_interface" "testnic" {
  depends_on          = [azurerm_subnet.testsubnet]
  name                = var.infra-config.nic_name
  location            = var.infra-config.resource_group_location
  resource_group_name = var.infra-config.resource_group_name

  ip_configuration {
    name                          = var.infra-config.ip_name
    subnet_id                     = azurerm_subnet.testsubnet.id
    private_ip_address_allocation = var.infra-config.private_ip_address_allocation
    public_ip_address_id          = azurerm_public_ip.testpublicip.id
  }
}

resource "azurerm_network_security_group" "testnsg" {
  name                = var.infra-config.nsg_name
  location            = var.infra-config.resource_group_location
  resource_group_name = var.infra-config.resource_group_name


  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_public_ip" "testpublicip" {
  name                = var.infra-config.public_ip_name
  resource_group_name = var.infra-config.resource_group_name
  location            = var.infra-config.resource_group_location
  allocation_method   = var.infra-config.allocation_method
}

resource "azurerm_network_interface_security_group_association" "testnsgallocation" {
  network_interface_id      = azurerm_network_interface.testnic.id
  network_security_group_id = azurerm_network_security_group.testnsg.id

}

resource "azurerm_linux_virtual_machine" "myvm" {
  depends_on            = [azurerm_network_interface.testnic]
  name                  = var.infra-config.vm_name
  resource_group_name   = var.infra-config.resource_group_name
  location              = var.infra-config.resource_group_location
  size                  = var.infra-config.vm_size
  admin_username        = var.infra-config.admin_username
  admin_password        = var.infra-config.admin_password
  network_interface_ids = [azurerm_network_interface.testnic.id]

  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

}
  