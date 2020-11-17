param location string
//param vnetResourceId string

var suffix = uniqueString(resourceGroup().id)
var appPlanName = 'applan-${suffix}'
var websiteName = 'websitedemo-${suffix}'


resource appplan 'Microsoft.Web/serverfarms@2019-08-01' = {
  name: appPlanName
  location: location
  properties: {
    name: appPlanName
  }
  sku: {
    name: 'S1'
    capacity: 1
  }
}

// resource website 'Microsoft.Web/sites@2019-08-01' = {
//   name: websiteName
//   location: location
//   dependsOn: [
//     appplan
//   ]
//   properties: {
//     serverFarmId: appplan.id
//     siteConfig: {
//       appSettings: []
//     }        
//   }  
// }