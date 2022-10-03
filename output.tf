output "resource_group_id" {
  description = "Resource Group ID"
  # Attribute Reference
  value = azurerm_resource_group.rg.id 
}
output "resource_group_name" {
  description = "Resource Group Name"
  # Argument Reference
  value = azurerm_resource_group.rg.name
}

# 2. Output Values for Virtual Network Resource
output "virtual_network" {
  description = "Virtal Network Name"
  value = azurerm_virtual_network.virtual_network.name  
  #sensitive = true  # Enable during Step-08
}

output "virtual_network_id" {
  description = "Virtal Network ID"
  value = azurerm_virtual_network.virtual_network.id  
  #sensitive = true  # Enable during Step-08
}
output "subnet_name" {
  description = "subnet_1 name"
  value = azurerm_subnet.subnet.name  
  #sensitive = true  # Enable during Step-08
}


output "subnet_id" {
  description = "subnet_id id"
  value = azurerm_subnet.subnet.id  
  #sensitive = true  # Enable during Step-08
}

output "subnet_gatewaysubnet_id" {
  description = "subnet_gatewaysubnet id"
  value = azurerm_subnet.subnet_GatewaySubnet.id  
  #sensitive = true  # Enable during Step-08
}

output "local_network_gateway_name" {
  description = "local_network_gateway_name"
  value = azurerm_local_network_gateway.home.name  
  #sensitive = true  # Enable during Step-08
}

output "local_network_gateway_id" {
  description = "local_network_gateway_id"
  value = azurerm_local_network_gateway.home.id  
  #sensitive = true  # Enable during Step-08
}