param location string
param aksSubnetId string 
param adminUsername string
param sshKey string
param fwPublicIp string
param vnetId string

var networkContributorId = concat(subscription().id, '/providers/Microsoft.Authorization/roleDefinitions/4d97b98b-1d4f-4787-a291-c67834d212e7')

resource aks 'Microsoft.ContainerService/managedClusters@2020-07-01' = {
  name: 'aks-egress'
  location: location
  identity: {
    type: 'SystemAssigned'
  }  
  properties: {
    kubernetesVersion: '1.17.13'
    dnsPrefix: 'aks-egress'
    enableRBAC: true
    servicePrincipalProfile: {
      clientId: 'msi'
      secret: null
    }
    networkProfile: {
      networkPlugin: 'azure'
      networkPolicy: 'azure'
      serviceCidr: '10.41.0.0/16'
      dnsServiceIP: '10.41.0.10'
      dockerBridgeCidr: '172.17.0.1/16'
      loadBalancerSku: 'standard'
      outboundType: 'userDefinedRouting'    
    }            
    agentPoolProfiles: [
      {
        name: 'systempool'
        count: 2
        vmSize: 'Standard_DS3_v2'
        osDiskSizeGB: 100
        vnetSubnetID: aksSubnetId        
        osType: 'Linux'
        maxCount: 5
        minCount: 2
        scaleSetPriority: 'Regular'
        enableAutoScaling: true
        mode: 'System'
        type: 'VirtualMachineScaleSets'
      }
    ]
    linuxProfile: {
      adminUsername: adminUsername      
      ssh: {
        publicKeys: [
          {
            keyData: sshKey
          }
        ]
      }
    }
    apiServerAccessProfile: {
      enablePrivateCluster: false     
      authorizedIPRanges: [
        fwPublicIp
      ] 
    }    
  }
}

// resource addRbacAks 'Microsoft.Network/virtualNetworks/providers/roleAssignments@2018-09-01-preview' = {
//   name: concat(split(vnetId,'/')[8],'/Microsoft.Authorization/',guid(resourceGroup().id,networkContributorId,'-aks-system-assigned-managed-identity-ilb'))
//   properties: {
//     roleDefinitionId: networkContributorId
//     principalId: reference(aks.id, '2020-03-01', 'Full').identity.principalId
//     scope: vnetId
//     principalType: 'ServicePrincipal'
//   }
// }