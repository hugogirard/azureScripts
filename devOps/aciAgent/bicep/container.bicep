param location string = 'eastus'
param imageRegistryServer string
param imagename string
param subnetId string
param registryAdmin string {
  secure: true
}
param registryPassword string {
  secure: true
}
param azureDevOpsOrg string {
  secure: true
}
param adoPat string {
  secure: true
}

var suffix = uniqueString(resourceGroup().id)
var aciname = concat('aci',suffix)

resource networkProfile 'Microsoft.Network/networkProfiles@2019-11-01' = {
  name: ''
  location: location
  properties: {
    containerNetworkInterfaceConfigurations: [
      {
        name: 'aciagent'
        properties: {
          ipConfigurations: [
            {
              name: ''
              properties: {
                subnet: {
                  id: subnetId
                }
              }
            }
          ]
        }
      }
    ]
  }
}

resource aci 'Microsoft.ContainerInstance/containerGroups@2019-12-01' = {
  name: aciname
  location: location
  dependsOn: [
    networkProfile
  ]
  properties: {
    containers: [
      {
        name: aciname
        properties: {
          image: imagename
          resources: {
            requests: {
              cpu: 1
              memoryInGB: '1.5'
            }
          }
        }
      }
    ]
    osType: 'Linux'
    restartPolicy: 'Never'
    imageRegistryCredentials: [
      {
        server: imageRegistryServer
        username: registryAdmin
        password: registryPassword
      }
    ]
    ipAddress: {
      type: 'Private'
      ports: [
      ]
    }
    networkProfile: {
      id: networkProfile.id
    }
    initContainers: [
      {
        name: 'agentConf'
        properties: {
          environmentVariables: [
            {
              name: 'AZP_URL'
              secureValue: azureDevOpsOrg
            }
            {
              name: 'AZP_TOKEN'
              secureValue: adoPat
            }
            {
              name: 'AZP_AGENT_NAME'
              value: aciname
            }
          ]
        }
      }
    ]    
  }
}