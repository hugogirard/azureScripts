param location string
param fwSubnetId string

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