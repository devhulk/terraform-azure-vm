provider "azurerm" {
  features {}
}

data "terraform_remote_state" "networking" {
  backend = "remote"
  config = {
    organization = var.org
    workspaces = {
      name = var.source_workspace
    }
  }
}

locals {
  pulled_subnets = tolist(data.terraform_remote_state.networking.outputs.subnets)
}


resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = data.terraform_remote_state.networking.outputs.resource_group_location
  resource_group_name = data.terraform_remote_state.networking.outputs.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = element(local.pulled_subnets, 0)  # azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "example" {
  name                = "example-machine"
  resource_group_name = data.terraform_remote_state.networking.outputs.resource_group_name
  location            = data.terraform_remote_state.networking.outputs.resource_group_location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = var.vm_pw
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

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
}