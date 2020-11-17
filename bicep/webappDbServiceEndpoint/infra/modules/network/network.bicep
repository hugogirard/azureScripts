param location string
param addressSpace string = '10.0.0.0/16'
param subnetWebAppAddressSpace string = '10.0.1.0/24'

var suffix = uniqueString(resourceGroup().id)
var vnetName = 'vnet-demo-${suffix}'

resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressSpace
      ]
    }
    subnets: [
      {
        name: 'webAppSubnet'
        properties: {
          addressPrefix: subnetWebAppAddressSpace
          delegations: [
            {
               name: 'webAppDelegation'
               properties: {
                 serviceName: 'Microsoft.Web/serverFarms'
               }
            }
          ]
        }
      }
    ]    
  }
}