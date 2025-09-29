param vm object
param location string
param tags object = {}
param subnetId string
param networkSecurityGroupId string
param dnsLabelPrefix string = toLower('${vm.name}-${uniqueString(resourceGroup().id)}')

resource publicIPAddressResource 'Microsoft.Network/publicIPAddresses@2024-07-01' = {
  name: '${vm.name}-pip'
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    publicIPAddressVersion: 'IPv4'
    dnsSettings: {
      domainNameLabel: dnsLabelPrefix
    }
    idleTimeoutInMinutes: 4
  }
}

resource networkInterfaceResource 'Microsoft.Network/networkInterfaces@2024-07-01' = {
  name: '${vm.name}-nic'
  tags: tags
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnetId
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddressResource.id
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: networkSecurityGroupId
    }
  }
}

resource virtualMachineResource 'Microsoft.Compute/virtualMachines@2024-11-01' = {
  name: vm.name
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    hardwareProfile: {
      vmSize: vm.size
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
      imageReference: vm.imageReference
      dataDisks: [for disk in (vm.dataDisks ?? []): {
        lun: disk.lun
        createOption: disk.createOption
        diskSizeGB: disk.diskSizeGB
        managedDisk: {
          storageAccountType: (disk.storageAccountType ?? 'Standard_LRS')
        }
      }]
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaceResource.id
        }
      ]
    }
    osProfile: {
      computerName: vm.name
      adminUsername: vm.adminUsername
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: '/home/${vm.adminUsername}/.ssh/authorized_keys'
              keyData: vm.sshPublicKey
            }
          ]
        }
      }
    }
  }
}

output vmManagedIdentityPrincipalId string = virtualMachineResource.identity.principalId
