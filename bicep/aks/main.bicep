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

module firewall './modules/firewall/firewall.bicep' = {
  name: 'firewall'
  params: {
    location: location
    fwSubnetId: networking.outputs.fwSubnetId
  }
}

module aks './modules/aks/aks.bicep' = {
  name: 'aks'
  params: {
    location: location
    strname: 'teststr'
    vnetId: networking.outputs.aksSubnetId
    vnetName: networking.outputs.vnetName
  }
}