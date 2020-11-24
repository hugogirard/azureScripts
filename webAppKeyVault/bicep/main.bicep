param vnetAddressSpace string = '10.0.0.0/16'
param subnetAddressSpace string = '10.0.0.0/24'

var location = resourceGroup().location
var suffix = uniqueString(resourceGroup().id)
var appplan = concat('appplan-',suffix)
var webAppName = {
  front: concat('frontweb-',suffix)
  back: concat('backend-',suffix)
}
var vnetName = concat('vnet-app-',suffix)
var vaultName = concat('vault-',suffix)

resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressSpace
      ]      
    }   
    subnets: [
      {
        name: 'webappSubnet'
        properties: {
          addressPrefix: subnetAddressSpace          
          serviceEndpoints: [
            {
              service: 'Microsoft.KeyVault'
              locations: [
                location
              ]
            }
          ]
          delegations: [
            {
              name: 'webAppDelegation'
              properties: {
                serviceName: 'Microsoft.Web/serverfarms'
              }
            }
          ]
        }                
      }
    ] 
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2019-08-01' = {
  name: appplan
  location: location
  dependsOn: [
    vnet
  ]
  sku: {
    name: 'S1'
  }
  kind: 'app'
}

resource webappBackend 'Microsoft.Web/sites@2019-08-01' = {
  name: webAppName.back
  location: location
  dependsOn: [
    appServicePlan
  ]
  properties: {
    serverFarmId: appServicePlan.id
  }
}


resource webappFront 'Microsoft.Web/sites@2019-08-01' = {
  name: webAppName.front
  location: location
  dependsOn: [
    appServicePlan
    webappBackend
  ]
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlan.id    
  }
}

resource appSettings 'Microsoft.Web/sites/config@2019-08-01' = {
  name: concat(webappFront.name,'/appsettings')
  dependsOn: [
    webappFront
  ]
  properties: {
    'API': 'https://${webappBackend.name}.azurewebsites.net/weather'
  }
}

resource frontvnetConnection 'Microsoft.Web/sites/networkConfig@2019-08-01' = {
  name: concat(webappFront.name,'/VirtualNetwork')
  dependsOn: [
    webappFront
  ]
  properties: {
    subnetResourceId: vnet.properties.subnets[0].id
  }
}

resource vault 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: vaultName
  location: location
  dependsOn: [
    vnet
  ]
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    networkAcls: {
      virtualNetworkRules: [
        {
          id: vnet.properties.subnets[0].id
        }
      ]
    }
  }
}