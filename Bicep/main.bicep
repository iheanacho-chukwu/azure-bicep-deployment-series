targetScope='subscription'

param resourceGroupUKSParam object
param tagsParam object
param vnetParam object
param vmParam object
param deploySSHParam bool = true

param deploymentNameParam string  = 'agentPool'

module resourceGroupUKS 'modules/resource-group.bicep' = {
  name: '${deploymentNameParam}-resourceGroup'
  params: {
    resourceGroup: resourceGroupUKSParam
    tags: tagsParam
  }
}

module virtualNetwork 'modules/virtual-network.bicep' = {
  name: '${deploymentNameParam}-virtual-network'
  scope: resourceGroup(resourceGroupUKSParam.name)
  params: {
    vnet: vnetParam
    location: resourceGroupUKSParam.location
    tags: tagsParam
    deploySSH: deploySSHParam
  }
  dependsOn: [
    resourceGroupUKS
  ]
}

module virtualMachine 'modules/virtual-machine.bicep' = {
  name: '${deploymentNameParam}-virtual-machine'
  scope: resourceGroup(resourceGroupUKSParam.name)
  params: {
    vm: vmParam
    location: resourceGroupUKSParam.location
    tags: tagsParam
    subnetId: virtualNetwork.outputs.subnetId
    networkSecurityGroupId: virtualNetwork.outputs.networkSecurityGroupId
  }
  dependsOn: [
    virtualNetwork
  ]
}

output subnetId string = virtualNetwork.outputs.subnetId
output networkSecurityGroupId string = virtualNetwork.outputs.networkSecurityGroupId
