param location string = 'eastus'
param vnetAddressSpace string = '10.0.0.0/16'
param subnetAddressSpace string = '10.0.1.0/24'

var suffix = uniqueString(resourceGroup().id)
var acrName = concat('acr',suffix)

resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: 'aci-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressSpace
      ]
    }
    subnets: [
      {
        name: 'aciSubnet'
        properties: {
          addressPrefix: subnetAddressSpace
          delegations: [
            {
              name: 'acidelegation'
              properties: {
                serviceName: 'Microsoft.ContainerInstance/containerGroups'                
              }
            }
          ]
        }
      }
    ]
  }
}

resource acr 'Microsoft.ContainerRegistry/registries@2019-05-01' = {
  name: acrName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    adminUserEnabled: true
  }
}

output acrname string = acr.name
output acrhostname string = '${acr.name}.azurecr.io'
output subnetId string = vnet.properties.subnets[0].id