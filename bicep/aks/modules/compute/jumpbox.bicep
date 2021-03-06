param location string
param subnetId string
param username string {
  secure: true
}
param sshKey string

resource pip 'Microsoft.Network/publicIpAddresses@2020-06-01' = {
  name: 'jumpbox-pip'
  location: location
  sku: {
    name: 'Standard'    
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2020-06-01' = {
  name: 'jumpbox-nic'
  location: location
  dependsOn: [
    pip
  ]
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig'
        properties: {
          subnet: {
            id: subnetId
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: pip.id
          }
        }
      }
    ]
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2020-06-01' = {
  name: 'jumpbox'
  location: location
  dependsOn: [
    nic
  ]
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B1s'
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '18.04-LTS'
        version: 'latest'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }    
    osProfile: {
      computerName: 'jumpbox'      
      adminUsername: username
      linuxConfiguration: {
        disablePasswordAuthentication: true        
        ssh: {
          publicKeys: [
            {
              path: concat('/home/',username,'/.ssh/authorized_keys')
              keyData: sshKey
            }            
          ]
        }
      }   
    }
  }
}

output ip string = pip.properties.ipAddress