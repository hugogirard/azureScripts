param location string

module web './modules/webapp/webapp.bicep' = {
  name: 'web'
  params: {
    location: location
  }
}