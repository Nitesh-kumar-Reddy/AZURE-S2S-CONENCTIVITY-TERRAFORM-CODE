resource "azurerm_resource_group" "rg" {
  name     = "stj-rg"
  location = "North Europe"

  tags = {
    name     = "nir"
    env      = "Development"
    archUUID = "633acbc3-1dcc-40e0-adf2-0231b228c71e"
  }
}

resource "azurerm_virtual_network" "virtual_network" {
  resource_group_name = azurerm_resource_group.rg.name
  name                = "stj-vnet"
  location            = "North Europe"

  address_space = [
    "10.0.0.0/16",
  ]

  tags = {
    env      = "Development"
    archUUID = "633acbc3-1dcc-40e0-adf2-0231b228c71e"
  }
}

resource "azurerm_subnet" "subnet" {
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  resource_group_name  = azurerm_resource_group.rg.name
  name                 = "subnet"

  address_prefixes = [
    "10.0.1.0/24",
  ]

  delegation {
    name = "delegation"
    service_delegation {
      name = "Microsoft.ContainerInstance/containerGroups"
    }
  }
}

resource "azurerm_subnet" "subnet_GatewaySubnet" {
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  resource_group_name  = azurerm_resource_group.rg.name
  name                 = "GatewaySubnet"
  depends_on = [
    azurerm_subnet.subnet
  ]
  address_prefixes = [
    "10.0.2.0/24",
  ]

  # delegation {
  #   name = "delegation"
  #   service_delegation {
  #     name = "Microsoft.ContainerInstance/containerGroups"
  #     actions = [
  #       "Microsoft.Network/virtualNetworks/subnets/join/action",
  #       "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
  #     ]
  #   }
  # }
}
resource "azurerm_subnet" "subnet_bastion" {
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  resource_group_name  = azurerm_resource_group.rg.name
  name                 = "AzureBastionSubnet"

  address_prefixes = [
    "10.0.3.0/24",
  ]

#  delegation {
#     name = "delegation"
#     service_delegation {
#       name = "Microsoft.ContainerInstance/containerGroups"
#       actions = [
#         "Microsoft.Network/virtualNetworks/subnets/join/action",
#       ]
#     }
#   }
}
resource "azurerm_public_ip" "public_ip" {
  resource_group_name = azurerm_resource_group.rg.name
  name                = "BastionPublicIp"
  location            = "North Europe"
  allocation_method   = "Static"
  sku                 = "Standard"
depends_on = [
  azurerm_subnet.subnet_bastion
]
  tags = {
    env      = "Development"
    archUUID = "633acbc3-1dcc-40e0-adf2-0231b228c71e"
  }
}

resource "azurerm_bastion_host" "bastion_host" {
  resource_group_name = azurerm_resource_group.rg.name
  name                = "Bastionhost"
  location            = "North Europe"
  depends_on = [
    azurerm_public_ip.public_ip
  ]
  ip_configuration {
    subnet_id            = azurerm_subnet.subnet_bastion.id
    public_ip_address_id = azurerm_public_ip.public_ip.id
    name                 = "ip_config"
  }

  tags = {
    env      = "Development"
    archUUID = "633acbc3-1dcc-40e0-adf2-0231b228c71e"
  }
}

resource "azurerm_local_network_gateway" "home" {
  name                = "backHome"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  gateway_address     = "12.13.14.15"
  address_space       = ["192.168.0.0/16"]
}


#VPN GATEWAY

resource "azurerm_public_ip" "vpngw-pip" {
  name                = "vpngw-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "example" {
  name                = "vpn-gw-sjh"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
 
  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "Basic"

  ip_configuration {
    public_ip_address_id          = azurerm_public_ip.vpngw-pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.subnet_GatewaySubnet.id
   
  }
}

resource "azurerm_virtual_network_gateway_connection" "onpremise" {
  name                = "onpremise"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  # depends_on = [
  #   azurerm_local_network_gateway.home,azurerm_virtual_network_gateway_connection
  # ]
  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.example.id
  local_network_gateway_id   = azurerm_local_network_gateway.home.id
  

  shared_key = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"
}

