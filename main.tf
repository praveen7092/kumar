provider "azurerm" {
    features {}
  
}
resource "azurerm_resource_group" "rg" {
    name="Demo-Rg"
    location ="east us"
  
}
resource "azurerm_virtual_network" "vn" {
    name="Demo_vn"
    location ="east us"
    address_space = [ "10.0.0.0/16" ]
    resource_group_name = azurerm_resource_group.rg.name
}
resource "azurerm_subnet" "sn" {
  name="Demo_Subnet"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vn.name
  address_prefixes = ["10.0.1.0/24"]
}
resource "azurerm_public_ip" "pb" {
    name="pip"
    location = "east us"
    resource_group_name = azurerm_resource_group.rg.name
    allocation_method = "Dynamic"
    sku = "Basic"
}
resource   "azurerm_network_interface"   "nic"   { 
   name   =   "myvm1-nic" 
   location   =   "east us" 
   resource_group_name   =   azurerm_resource_group.rg.name 

   ip_configuration   { 
     name   =   "ipconfig1" 
     subnet_id   =   azurerm_subnet.sn.id 
     private_ip_address_allocation   =   "Dynamic" 
     public_ip_address_id   =azurerm_public_ip.pb.name 
   } 
 }

 resource   "azurerm_windows_virtual_machine"   "vm"   { 
   name                    =   "myvm1"   
   location                =   "east us" 
   resource_group_name     =   azurerm_resource_group.rg.name 
   network_interface_ids   =   [ azurerm_network_interface.nic.id ] 
   size                    =   "Standard_B1s" 
   admin_username          =   "kumar1132" 
   admin_password          =   "Password1234" 

   source_image_reference   { 
     publisher   =   "MicrosoftWindowsServer" 
     offer       =   "WindowsServer" 
     sku         =   "2019-Datacenter" 
     version     =   "latest" 
   } 

   os_disk   { 
     caching             =   "ReadWrite" 
     storage_account_type   =   "Standard_LRS" 
   } 
 }