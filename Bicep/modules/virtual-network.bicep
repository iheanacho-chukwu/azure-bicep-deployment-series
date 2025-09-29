param location string
param tags object = {}
param vnet object
param deploySSH bool = false

resource virtualNetworkResource 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  name: vnet.name
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnet.addressPrefix
      ]
    }
    subnets: [
      {
        name: vnet.subnetName
        properties: {
          addressPrefix: vnet.subnetAddressPrefix
        }
      }
    ]
  }
}

resource networkSecurityGroupResource 'Microsoft.Network/networkSecurityGroups@2024-07-01' = {
  name: '${vnet.name}-nsg-01'
  location: location
}

resource https8443Rule 'Microsoft.Network/networkSecurityGroups/securityRules@2024-07-01' = {
  parent: networkSecurityGroupResource
  name: 'https_8443'
  properties: {
    description: 'https'
    priority: 100
    direction: 'Inbound'
    access: 'Allow'
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRange: '8443'
    sourceAddressPrefix: 'Internet'
    destinationAddressPrefix: '*'
  }
}

resource http8080Rule 'Microsoft.Network/networkSecurityGroups/securityRules@2024-07-01' = {
  parent: networkSecurityGroupResource
  name: 'http_8080'
  properties: {
    description: 'http plain text'
    priority: 101
    direction: 'Inbound'
    access: 'Allow'
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRange: '8080'
    sourceAddressPrefix: 'Internet'
    destinationAddressPrefix: '*'
  }
}

resource ssh122Rule 'Microsoft.Network/networkSecurityGroups/securityRules@2024-07-01' = {
  parent: networkSecurityGroupResource
  name: 'ssh_port_122'
  properties: {
    description: 'Allow admin SSH'
    priority: 102
    direction: 'Inbound'
    access: 'Allow'
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRange: '122'
    sourceAddressPrefix: 'Internet'
    destinationAddressPrefix: '*'
  }
}

resource vpn1194Rule 'Microsoft.Network/networkSecurityGroups/securityRules@2024-07-01' = {
  parent: networkSecurityGroupResource
  name: 'vpn_1194'
  properties: {
    description: 'Allow VPN'
    priority: 103
    direction: 'Inbound'
    access: 'Allow'
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRange: '1194'
    sourceAddressPrefix: 'Internet'
    destinationAddressPrefix: '*'
  }
}

resource snmp161Rule 'Microsoft.Network/networkSecurityGroups/securityRules@2024-07-01' = {
  parent: networkSecurityGroupResource
  name: 'snmp_161'
  properties: {
    description: 'Allow SNMP'
    priority: 104
    direction: 'Inbound'
    access: 'Allow'
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRange: '161'
    sourceAddressPrefix: 'Internet'
    destinationAddressPrefix: '*'
  }
}

resource https443Rule 'Microsoft.Network/networkSecurityGroups/securityRules@2024-07-01' = {
  parent: networkSecurityGroupResource
  name: 'https_443'
  properties: {
    description: 'Allow HTTPS'
    priority: 105
    direction: 'Inbound'
    access: 'Allow'
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRange: '443'
    sourceAddressPrefix: 'Internet'
    destinationAddressPrefix: '*'
  }
}

resource http80Rule 'Microsoft.Network/networkSecurityGroups/securityRules@2024-07-01' = {
  parent: networkSecurityGroupResource
  name: 'http_80'
  properties: {
    description: 'Allow HTTP'
    priority: 106
    direction: 'Inbound'
    access: 'Allow'
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRange: '80'
    sourceAddressPrefix: 'Internet'
    destinationAddressPrefix: '*'
  }
}

resource ssh22Rule 'Microsoft.Network/networkSecurityGroups/securityRules@2024-07-01' = {
  parent: networkSecurityGroupResource
  name: 'ssh_22'
  properties: {
    description: 'Allow Git SSH'
    priority: 107
    direction: 'Inbound'
    access: 'Allow'
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRange: '22'
    sourceAddressPrefix: 'Internet'
    destinationAddressPrefix: '*'
  }
}

resource git9418Rule 'Microsoft.Network/networkSecurityGroups/securityRules@2024-07-01' = {
  parent: networkSecurityGroupResource
  name: 'git_9418'
  properties: {
    description: 'Allow Git'
    priority: 108
    direction: 'Inbound'
    access: 'Allow'
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRange: '9418'
    sourceAddressPrefix: 'Internet'
    destinationAddressPrefix: '*'
  }
}

resource smtp25Rule 'Microsoft.Network/networkSecurityGroups/securityRules@2024-07-01' = {
  parent: networkSecurityGroupResource
  name: 'smtp_25'
  properties: {
    description: 'Allow SMTP'
    priority: 109
    direction: 'Inbound'
    access: 'Allow'
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRange: '25'
    sourceAddressPrefix: 'Internet'
    destinationAddressPrefix: '*'
  }
}

output subnetId string = virtualNetworkResource.properties.subnets[0].id
output networkSecurityGroupId string = networkSecurityGroupResource.id
