terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "res_1"
  location = "East us"
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_virtual_network" "v1" {
  name                = "first_vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/16"]
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_subnet" "s1" {
  name                 = "snet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.v1.name
  address_prefixes     = ["10.0.1.0/24"]
  lifecycle {
    prevent_destroy = true
  }
}
resource "azurerm_network_interface" "nic1" {
  name                = "first-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.s1.id
    private_ip_address_allocation = "Dynamic"
  }
  lifecycle {
    prevent_destroy = true
  }
}
resource "azurerm_windows_virtual_machine" "vm" {
  name                = "V-machine"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [azurerm_network_interface.nic1.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  lifecycle {
    prevent_destroy = true
  }
}  
resource "azurerm_storage_account" "strg" {
  name                     = "uniquestoragename123"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier              = "Hot"
  lifecycle {
    prevent_destroy = true
  }
}
resource "azurerm_storage_container" "cnt" {
  name                  = "containerdata"
  storage_account_name  = azurerm_storage_account.strg.name
  container_access_type = "private"
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_blob" "example" {
  name                   = "stringblob"
  storage_account_name   = azurerm_storage_account.strg.name
  storage_container_name = azurerm_storage_container.cnt.name
  type                   = "Block"
  source                 = "C:\\Users\\user\\OneDrive\\Documents\\string.txt"
  lifecycle {
    prevent_destroy = true
  }
}
resource "azurerm_resource_group" "rg2" {
  name     = "${var.rgname}"
  location = "${var.rgloc}"
}
resource "azurerm_virtual_network" "v2" {
  name                = "${var.virnet}"
  resource_group_name = "${azurerm_resource_group.rg2.name}"
  location            = "${azurerm_resource_group.rg2.location}"
  address_space       = ["${var.addrspace}"]
}
resource "azurerm_subnet" "s2" {
  name                 = "${var.sunet}"
  resource_group_name  = azurerm_resource_group.rg2.name
  virtual_network_name = azurerm_virtual_network.v2.name
  address_prefixes     = ["${var.snetaddrsp}"]
}