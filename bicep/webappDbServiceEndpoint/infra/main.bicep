param location string = 'eastus'

module web './modules/webapp/webapp.bicep' = {
  name: 'web'
  params: {
    location: location
  }
}