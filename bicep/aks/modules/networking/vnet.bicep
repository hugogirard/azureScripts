param location string
param addressPrefixHub string
param addressPrefixSpoke string
param addressPrefixSubnetFw string
param addressPrefixJumpboxSubnet string
param addressPrefixSubnetAks string

resource hubvnet 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: 'vnet-hub'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefixHub
      ]
    }
    subnets: [
      {
        name: 'AzureFirewallSubnet'
        properties: {
          addressPrefix: addressPrefixSubnetAks
        }
      }
      {
        name: 'jumpboxSubnet'
        properties: {
          addressPrefix: addressPrefixJumpboxSubnet
        }
      }
    ]
  }
}

resource spokeVnet 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: 'spoke-hub'
  location: location
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
        }
      }
    ]
  }
}

// resource peeringHubToSpoke 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2019-11-01' = {
//   name: concat(hubvnet.name,'/hubToSpoke')
//   dependsOn: [
//     hubvnet
//     spokeVnet
//   ]
//   properties: {
//     remoteVirtualNetwork: {
//       id: spokeVnet.id
//     }
//   }
// }

// resource peeringSpokeToHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-06-01' = {
//   name: concat(spokeVnet.name,'/spokeToHub')
//   dependsOn: [
//     hubvnet
//     spokeVnet
//     peeringHubToSpoke
//   ]
//   properties: {
//     remoteVirtualNetwork: {
//       id: hubvnet.id
//     }
//   }
// }