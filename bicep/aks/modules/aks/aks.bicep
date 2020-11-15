param location string
param aksSubnetId string 
param adminUsername string
param sshKey string
param fwPublicIp string

var networkContributorId = '4d97b98b-1d4f-4787-a291-c67834d212e7'

// resource str 'Microsoft.Storage/storageAccounts@2019-06-01' = {
//   name: strname
//   location: location
//   sku: {
//     name: 'Standard_LRS'
//   }
//   kind: 'StorageV2'
// }

// resource privateEndpoint 'Microsoft.Network/privateEndpoints@2020-04-01' = {
//   name: ''
//   location: location
//   dependsOn: [
//     str
//   ]
//   properties: {
//     privateLinkServiceConnections: [
//       {
//         name: ''
//         properties: {
//           privateLinkServiceId: str.id
//         }
//       }
//     ]
//   }
// }

// resource dns 'Microsoft.Network/privateDnsZones@2020-01-01' = {
//   name: 'hugirard.com'
//   location: 'global'
//   properties: {
//     maxNumberOfRecordSets: 25000
//     maxNumberOfVirtualNetworkLinks: 1000
//     maxNumberOfVirtualNetworkLinksWithRegistration: 100
//   }
// }

// resource vnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-01-01' = {
//   name: concat(dns.name,'/link_to_',toLower(vnetName))
//   location: 'global'
//   dependsOn: [
//     dns
//   ]
//   properties: {
//     registrationEnabled: false
//     virtualNetwork: {
//       id: vnetId
//     }
//   }
// }

// resource dnsZoneGroups 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2020-03-01' = {
//   name: concat()
// }

resource identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: 'aksIdentity'
  location: location  
}

resource role 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(resourceGroup().id)
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions',networkContributorId)
    principalId: identity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

// resource aks 'Microsoft.ContainerService/managedClusters@2020-07-01' = {
//   name: 'aks-egress'
//   location: location
//   identity: {
//     type: 'SystemAssigned'
//   }  
//   properties: {
//     kubernetesVersion: '1.17.13'
//     dnsPrefix: 'aks-egress'
//     enableRBAC: true
//     networkProfile: {
//       networkPlugin: 'azure'
//       networkPolicy: 'azure'
//       serviceCidr: '10.41.0.0/16'
//       dnsServiceIP: '10.41.0.10'
//       dockerBridgeCidr: '172.17.0.1/16'
//       loadBalancerSku: 'standard'
//       outboundType: 'userDefinedRouting'    
//     }            
//     agentPoolProfiles: [
//       {
//         name: 'systempool'
//         count: 2
//         vmSize: 'Standard_DS3_v2'
//         osDiskSizeGB: 100
//         vnetSubnetID: aksSubnetId        
//         osType: 'Linux'
//         maxCount: 5
//         minCount: 2
//         scaleSetPriority: 'Regular'
//         enableAutoScaling: true
//         mode: 'System'
//         type: 'VirtualMachineScaleSets'
//       }
//     ]
//     linuxProfile: {
//       adminUsername: adminUsername      
//       ssh: {
//         publicKeys: [
//           {
//             keyData: sshKey
//           }
//         ]
//       }
//     }
//     apiServerAccessProfile: {
//       enablePrivateCluster: false     
//       authorizedIPRanges: [
//         fwPublicIp
//       ] 
//     }    
//   }
// }

