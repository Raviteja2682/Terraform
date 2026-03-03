#Providing the subscriptioon details
provider "azurerm" {
  features {}
  subscription_id                 = "c28040d2-c232-4150-8299-a9fe33fa6aa1"
  resource_provider_registrations = "none"
}
# Create Resource Group
resource "azurerm_resource_group" "rg_hub" {
  name     = "AZR-CI-CONN-VNET-RG"
  location = "Central India"
}
 
# Create Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "AZR-CI-CONN-VNET"
  location            = azurerm_resource_group.rg_hub.location
  resource_group_name = azurerm_resource_group.rg_hub.name
  address_space       = ["10.20.0.0/23"]
}
 
resource "azurerm_subnet" "Firewall_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.rg_hub.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.20.0.64/26"]
}
 
resource "azurerm_subnet" "FirewallManagementSubnet" {
  name                 = "AzureFirewallManagementSubnet"
  resource_group_name  = azurerm_resource_group.rg_hub.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.20.0.128/26"]
}
 
resource "azurerm_subnet" "Gateway_subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.rg_hub.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.20.0.32/27"]
}
 
resource "azurerm_subnet" "Bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg_hub.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.20.0.0/27"]
}
 
resource "azurerm_subnet" "Resolver_Subnet" {
  name                 = "Resolver_Subnet"
  resource_group_name  = azurerm_resource_group.rg_hub.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.20.0.192/27"]
}
 