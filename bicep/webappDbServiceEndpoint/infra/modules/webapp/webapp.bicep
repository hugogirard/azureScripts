param location string

var suffix = uniqueString(resourceGroup().id)
var appPlanName = 'applan=${suffix}'

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