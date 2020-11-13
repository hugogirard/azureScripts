param location string
param addressPrefixHub string
param addressPrefixSpoke string
param addressPrefixSubnetFw string
param addressJumpboxSubnet string
param addressPrefixSubnetAks string

module networking './modules/networking/vnet.bicep' = {
  name: 'networking'
  params: {
    location: location
    addressPrefixHub: addressPrefixHub
    addressPrefixSpoke: addressPrefixSpoke
    addressPrefixJumpboxSubnet: addressJumpboxSubnet
    addressPrefixSubnetAks: addressPrefixSubnetAks
    addressPrefixSubnetFw: addressPrefixSubnetFw
  }
}