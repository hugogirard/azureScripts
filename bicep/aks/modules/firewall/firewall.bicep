param location string
param fwSubnetId string

resource pip 'Microsoft.Network/publicIPAddresses@2020-06-01' = {
  name: 'pipfw'
  location: location
  sku: {
    name: 'Standard'    
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
  }
}

resource fw 'Microsoft.Network/azureFirewalls@2020-06-01' = {
  name: 'azureFw'
  location: location
  dependsOn: [
    pip
  ]  
  properties: {
    ipConfigurations: [
      {
        name: 'azureFirewallIpConfigurations'
        properties: {
          subnet: {
            id: fwSubnetId
          }
          publicIPAddress: {
            id: pip.id
          }
        }
      }
    ]
  }
}

// resource routeTable 'Microsoft.Network/routeTables@2020-06-01' = {
//   name: 'fwrt'
// }