param addressPrefixSpoke string
param addressPrefixSubnetAks string
param location string 
param firewallPrivateIp string
param firewallPublicIp string
param hubVnetName string
param hubVnetId string

resource routeTable 'Microsoft.Network/routeTables@2020-06-01' = {
  name: 'fwRoute'
  location: location
  properties: {
    routes: [
      {
        name: 'aksToFw'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallPrivateIp
        }
      }
      {
        name: 'fwToInternet'
        properties: {
          addressPrefix: '${firewallPublicIp}/32'
          nextHopType: 'Internet'
        }
      }
    ]
  }
}


resource spokeVnet 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: 'spoke-hub'
  location: location
  dependsOn: [
    routeTable
  ]
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefixSpoke
      ]
    }
    subnets: [
      {
        name: 'aksSubnet'
        properties: {
          addressPrefix: addressPrefixSubnetAks
          routeTable: {
            id: routeTable.id
          }
        }      
      }
    ]
  }
}

resource peeringHubToSpoke 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2019-11-01' = {
  name: concat(hubVnetName,'/hubToSpoke')
  dependsOn: [    
    spokeVnet
  ]
  properties: {
    remoteVirtualNetwork: {
      id: spokeVnet.id
    }
  }
}

resource peeringSpokeToHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-06-01' = {
  name: concat(spokeVnet.name,'/spokeToHub')
  dependsOn: [    
    spokeVnet
    peeringHubToSpoke
  ]
  properties: {
    remoteVirtualNetwork: {
      id: hubVnetId
    }
  }
}

output aksSubnetId string = spokeVnet.properties.subnets[0].id
output aksSubnetName string = spokeVnet.properties.subnets[0].name