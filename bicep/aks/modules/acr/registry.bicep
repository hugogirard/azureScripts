param location string


resource acr 'Microsoft.ContainerRegistry/registries@2019-05-01' = {
  name: 'acrregistrydemo21'
  location: location
  sku: {
    name: 'Standard'
  }
}