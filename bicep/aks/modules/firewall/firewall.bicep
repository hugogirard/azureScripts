param location string
param fwSubnetId string
param vnetName string
param aksSubnetName string

resource pip 'Microsoft.Network/publicIPAddresses@2020-06-01' = {
  name: 'pipfw'
  location: location
  sku: {
    name: 'Standard'    
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
  }
}

resource fw 'Microsoft.Network/azureFirewalls@2020-06-01' = {
  name: 'azureFw'
  location: location
  dependsOn: [
    pip
  ]  
  properties: {
    additionalProperties: {
      'Network.DNS.EnableProxy': 'True'
      'Network.DNS.RequireProxyForNetworkRules': 'True'
    }
    ipConfigurations: [
      {
        name: 'azureFirewallIpConfigurations'
        properties: {
          subnet: {
            id: fwSubnetId
          }
          publicIPAddress: {
            id: pip.id
          }
        }
      }
    ]
    networkRuleCollections: [
      {
        name: 'aksfwnr'
        properties: {
          priority: 100
          action: {
            type: 'Allow'
          }
          rules: [
            {
              name: 'apiudp'
              protocols: [
                'UDP'
              ]
              sourceAddresses: [
                '*'
              ]
              destinationAddresses: [
                'AzureCloud.eastus'
              ]
              sourceIpGroups: []
              destinationIpGroups: []
              destinationFqdns: []
              destinationPorts: [
                '1194'
              ]
            }
            {
              name: 'apitcp'
              protocols: [
                'TCP'
              ]
              sourceAddresses: [
                '*'
              ]
              destinationAddresses: [
                'AzureCloud.eastus'
              ]
              sourceIpGroups: []
              destinationIpGroups: []
              destinationFqdns: []
              destinationPorts: [
                '9000'
              ]
            }
            {
              name: 'time'
              protocols: [
                'UDP'
              ]
              sourceAddresses: [
                '*'
              ]
              destinationAddresses: []
              sourceIpGroups: []
              destinationIpGroups: []
              destinationFqdns: [
                'ntp.ubuntu.com'
              ]
              destinationPorts: [
                '123'
              ]
            }
          ]          
        }        
      }
    ]
    applicationRuleCollections: [
      {
        name: 'aksfwar'
        properties: {
          priority: 100
          action: {
            type: 'Allow'
          }
          rules: [
            {
              name: 'fqdn'
              protocols: [
                {
                  protocolType: 'Http'
                  port: 80
                }
                {
                  protocolType: 'Https'
                  port: 443
                }                                
              ]
              fqdnTags: [
                'AzureKubernetesService'
              ]
              targetFqdns: []
              sourceAddresses: [
                '*'
              ]
              sourceIpGroups: []
            }
          ]                  
        }
      }
    ]
    natRuleCollections: []
  }
}

resource routeTable 'Microsoft.Network/routeTables@2020-06-01' = {
  name: 'fwRoute'
  location: location
  dependsOn: [
    fw
  ]
  properties: {
    routes: [
      {
        name: 'aksToFw'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: fw.properties.hubIPAddresses.privateIPAddress
        }
      }
      {
        name: 'fwToInternet'
        properties: {
          addressPrefix: '${pip.properties.ipAddress}/32'
          nextHopType: 'Internet'
        }
      }
    ]
  }
}

// Update the subnet with route table
resource aksSubnet 'Microsoft.Network/virtualNetworks/subnets@2020-06-01' = {
  name: concat(vnetName,'/',aksSubnetName)
  dependsOn: [
    routeTable
  ]
  properties: {
    routeTable: {
      id: routeTable.id
    }
  }
}

output fwIp string = pip.properties.ipAddress