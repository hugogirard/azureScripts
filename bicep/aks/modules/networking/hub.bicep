param location string
param addressPrefixHub string
param addressPrefixSubnetFw string
param addressPrefixJumpboxSubnet string


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
          addressPrefix: addressPrefixSubnetFw
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



output fwSubnetId string = hubvnet.properties.subnets[0].id
output jumboxSubnetId string = hubvnet.properties.subnets[1].id
output hubVnetId string = hubvnet.id
output vnetName string = hubvnet.name