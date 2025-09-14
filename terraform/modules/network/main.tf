# VNet and subnets (public/private across two AZs via separate subnets)
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = [var.vnet_cidr]
}
 
# Two public subnets (for LoadBalancers / ingress) and two private subnets (for AKS nodes)
resource "azurerm_subnet" "public_1" {
  name                 = "${var.prefix}-public-1"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.public_subnet_1_cidr]
}
 
resource "azurerm_subnet" "public_2" {
  name                 = "${var.prefix}-public-2"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.public_subnet_2_cidr]
}
 
resource "azurerm_subnet" "private_1" {
  name                 = "${var.prefix}-private-1"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.private_subnet_1_cidr]
  delegations {
    name = "aks-delegation1"
    service_delegation {
      name = "Microsoft.ContainerService/managedClusters"
    }
  }
}
 
resource "azurerm_subnet" "private_2" {
  name                 = "${var.prefix}-private-2"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.private_subnet_2_cidr]
  delegations {
    name = "aks-delegation2"
    service_delegation {
      name = "Microsoft.ContainerService/managedClusters"
    }
  }
}
 
# Public NSG allowing HTTP/HTTPS/SSH
resource "azurerm_network_security_group" "public_nsg" {
  name                = "${var.prefix}-public-nsg"
  resource_group_name = var.resource_group_name
  location            = var.location
 
  security_rule {
    name                       = "AllowHTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowSSH"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
 
resource "azurerm_subnet_network_security_group_association" "public1_assoc" {
  subnet_id                 = azurerm_subnet.public_1.id
  network_security_group_id = azurerm_network_security_group.public_nsg.id
}
resource "azurerm_subnet_network_security_group_association" "public2_assoc" {
  subnet_id                 = azurerm_subnet.public_2.id
  network_security_group_id = azurerm_network_security_group.public_nsg.id
}
 
# Private NSG: deny inbound from internet
resource "azurerm_network_security_group" "private_nsg" {
  name                = "${var.prefix}-private-nsg"
  resource_group_name = var.resource_group_name
  location            = var.location
 
  security_rule {
    name                       = "DenyInternetInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
 
resource "azurerm_subnet_network_security_group_association" "private1_assoc" {
  subnet_id                 = azurerm_subnet.private_1.id
  network_security_group_id = azurerm_network_security_group.private_nsg.id
}
resource "azurerm_subnet_network_security_group_association" "private2_assoc" {
  subnet_id                 = azurerm_subnet.private_2.id
  network_security_group_id = azurerm_network_security_group.private_nsg.id
}
 
# NAT Gateway with 1 public IP (can be extended) and association to both private subnets
resource "azurerm_public_ip" "nat_ip" {
  name                = "${var.prefix}-nat-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}
 
resource "azurerm_nat_gateway" "nat" {
  name                = "${var.prefix}-nat"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name            = "Standard"
}
 
resource "azurerm_nat_gateway_public_ip_association" "nat_assoc" {
  nat_gateway_id       = azurerm_nat_gateway.nat.id
  public_ip_address_id = azurerm_public_ip.nat_ip.id
}
 
resource "azurerm_subnet_nat_gateway_association" "private1_nat_assoc" {
  subnet_id      = azurerm_subnet.private_1.id
  nat_gateway_id = azurerm_nat_gateway.nat.id
}
resource "azurerm_subnet_nat_gateway_association" "private2_nat_assoc" {
  subnet_id      = azurerm_subnet.private_2.id
  nat_gateway_id = azurerm_nat_gateway.nat.id
}
 