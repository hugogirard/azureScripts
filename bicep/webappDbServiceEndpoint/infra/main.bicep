param location string

var suffix = uniqueString(resourceGroup().id)
var appPlanName = 'applan=${suffix}'

resource appplan 'Microsoft.Web/serverfarms@2018-11-01' = {
  name: appPlanName
  location: location
  properties: {
    name: appPlanName
    workerSize: 0
    workerSizeId: 0
    numberOfWorkers: 1
  }
  sku: {
    name: 'Standard'
    skuCode: 'S1'
  }
}