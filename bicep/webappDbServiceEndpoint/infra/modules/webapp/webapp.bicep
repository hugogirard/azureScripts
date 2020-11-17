param location string

var suffix = uniqueString(resourceGroup().id)
var appPlanName = 'applan=${suffix}'

resource appplan 'Microsoft.Web/serverfarms@2018-02-01' = {
  name: appPlanName
  location: location
  properties: {
  }
  sku: {
    name: 'Standard'
    tier: 'S1'
  }
}