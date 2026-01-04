terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  # Your specific Subscription ID
  subscription_id = "3b5728ab-52cc-44c8-b49d-9a179c4dd97d"
}

# 1. Create the Resource Group
resource "azurerm_resource_group" "titan_backup" {
  name     = "Titan-Failover-RG"
  location = "East US"
}

# 2. Create the Network
resource "azurerm_virtual_network" "titan_net" {
  name                = "titan-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.titan_backup.location
  resource_group_name = azurerm_resource_group.titan_backup.name
}

# 3. Create the Subnet
resource "azurerm_subnet" "titan_subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.titan_backup.name
  virtual_network_name = azurerm_virtual_network.titan_net.name
  address_prefixes     = ["10.0.1.0/24"]
}

# 4. Create the Public IP (Static IP for Domain Stability)
resource "azurerm_public_ip" "titan_ip" {
  name                = "titan-public-ip"
  location            = azurerm_resource_group.titan_backup.location
  resource_group_name = azurerm_resource_group.titan_backup.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# 5. Create the Network Interface
resource "azurerm_network_interface" "titan_nic" {
  name                = "titan-nic"
  location            = azurerm_resource_group.titan_backup.location
  resource_group_name = azurerm_resource_group.titan_backup.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.titan_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.titan_ip.id
  }
}

# 6. Generate SSH Key (Automated Security)
resource "tls_private_key" "titan_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# 7. Save Key to Local Machine (Ignored by Git)
resource "local_file" "private_key" {
  content         = tls_private_key.titan_ssh.private_key_pem
  filename        = "titan_key.pem"
  file_permission = "0600"
}

# 8. Create the Server (The Unkillable Node)
resource "azurerm_linux_virtual_machine" "titan_vm" {
  name                = "Titan-Cloud-Node"
  resource_group_name = azurerm_resource_group.titan_backup.name
  location            = azurerm_resource_group.titan_backup.location
  
  # UPDATED: Matches Resume "Vertical Scaling" Story (16GB RAM for AI)
  # Note: Change back to "Standard_B1s" if you want to save money while testing.
  size                = "Standard_B4ms"
  
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.titan_nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = tls_private_key.titan_ssh.public_key_openssh
  }

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

  # Bootstrapping the "Skeleton" Page
  custom_data = base64encode(<<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y nginx
              echo '<html><body style="background-color:black; color:#00ff00; font-family:monospace; font-size:40px; text-align:center; padding-top:20%;"><h1>PROJECT TITAN: CLOUD NODE</h1><p>STATUS: UNKILLABLE</p><p>LOCATION: EAST US (Azure)</p></body></html>' > /var/www/html/index.html
              EOF
  )
}

# 9. Output the IP (For DNS Configuration)
output "server_ip" {
  value = azurerm_linux_virtual_machine.titan_vm.public_ip_address
}
