param location string
param addressPrefixHub string
param addressPrefixSpoke string
param addressPrefixSubnetFw string
param addressJumpboxSubnet string
param addressPrefixSubnetAks string
param adminUsername string
param sshKey string

module hubvnet './modules/networking/hub.bicep' = {
  name: 'hubvnet'
  params: {
    location: location
    addressPrefixHub: addressPrefixHub
    addressPrefixJumpboxSubnet: addressJumpboxSubnet
    addressPrefixSubnetFw: addressPrefixSubnetFw
  }
}

module firewall './modules/firewall/firewall.bicep' = {
  name: 'firewall'
  dependsOn: [
    hubvnet
  ]
  params: {
    location: location
    fwSubnetId: hubvnet.outputs.fwSubnetId
  }
}

module spokevnet './modules/networking/spoke.bicep' = {
  name: 'spokevnet'
  dependsOn: [
    hubvnet
    firewall
  ]
  params: {
    addressPrefixSpoke: addressPrefixSpoke
    addressPrefixSubnetAks: addressPrefixSubnetAks
    location: location
    firewallPrivateIp: firewall.outputs.fwPrivateIp
    firewallPublicIp: firewall.outputs.fwIp
    hubVnetName: hubvnet.outputs.vnetName
    hubVnetId: hubvnet.outputs.hubVnetId
  }
}

module aks './modules/aks/aks.bicep' = {
  name: 'aks'
  dependsOn: [
    spokevnet
  ]
  params: {
    location: location
    aksSubnetId: spokevnet.outputs.aksSubnetId
    fwPublicIp: firewall.outputs.fwIp
    adminUsername: adminUsername
    sshKey: sshKey
    vnetId: spokevnet.outputs.vnetId
  }
}