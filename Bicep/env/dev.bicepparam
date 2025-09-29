using '../main.bicep'

param deploymentNameParam = 'githubenterpriseserver'

param resourceGroupUKSParam = {
  name: 'demo'
  location: 'uksouth'
}

param tagsParam = {
  owner: 'nacho'
  workload: 'ghes'
  application: 'Github Enterprise Server'
  env: 'lab'
}

param vnetParam = {
  name: 'ghes-vnet'
  subnetName: 'default'
  addressPrefix: '10.0.0.0/16'
  subnetAddressPrefix: '10.0.2.0/24'
}

param vmParam = {
  name: 'ghes-vm'
  size: 'Standard_D2s_v3'
  imageReference: {
    publisher: 'GitHub'
    offer: 'GitHub-Enterprise'
    sku: 'github-enterprise-gen2'
    version: 'latest'
  }
  adminUsername: 'ghes'
  sshPublicKey: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDUDKLIeFGM51SPtPiZ28x1bVVywujGsSOIE39f3ehVZuGBIZQsDs7UPj5eT9AHBMuBCt/2upB1NuaBf8IB9yKuRNHX0qvLKCqiHAC1Hk7Sjzz51uRVkc/xXYR93lppLfZaVWYSxRa2CkZQD6mitwznnM9xpvCnb9WUig/RDMgxjpUz1Jlav/4WPxkVyGZb1PTHLwGt0fsqVBgtKo1eJ7oHQpIXFR8CXuLoJqOTlxXJ7ThqyCVW8ZiRwAh9+wB5QC0Y/Moo45BecAoBb/YlRYiWrFmUhybhcihd+G2pUXcrIjWeom06P/kb8rpH/LrRSYrbLkoqh5Cm3ws2HMiobYTR iheanacho.chukwu@outlook.com'
  dataDisks: [
    {
      lun: 0
      createOption: 'Empty'
      diskSizeGB: 512
      storageAccountType: 'StandardSSD_LRS'
    }
  ]
}
