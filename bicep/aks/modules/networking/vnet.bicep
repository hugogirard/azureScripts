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
          addressPrefixes: [
            addressPrefixSubnetFw
          ]
        }
      }
      {
        name: 'jumpboxSubnet'
        properties: {
          addressPrefixes: [
            addressPrefixJumpboxSubnet
          ]
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
          addressPrefixes: [
            addressPrefixSubnetAks
          ]
        }
      }
    ]
  }
}

resource peeringHubToSpoke 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-06-01' = {
  name: 'hubToSpoke'
  dependsOn: [
    hubvnet
    spokeVnet
  ]
  properties: {
    remoteAddressSpace: {
      addressPrefixes: [
        addressPrefixSpoke
      ]
    }
  }
}

resource peeringSpokeToHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-06-01' = {
  name: 'spokeToHub'
  dependsOn: [
    hubvnet
    spokeVnet
    peeringHubToSpoke
  ]
  properties: {
    remoteAddressSpace: {
      addressPrefixes: [
        addressPrefixHub
      ]
    }
  }
}