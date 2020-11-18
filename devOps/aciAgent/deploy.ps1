# This script compile the bicep template and deploy it
param(
    [string]$resourceGroup = 'aci-demo-agent-rg',
    [string]$location = 'eastus'
)

az group create -n $resourceGroup -l $location

bicep build .\bicep\network.bicep
bicep build .\bicep\container.bicep

$outputs = az deployment group create --resource-group $resourceGroup --template-file .\bicep\network.json

Write-Host "ACR name : $outputs"

# Login to ACR
#az acr login -n $acrname

# Pull the agent and push it using ACR task
#az acr build --image dockeragent:latest --registry $acrname --file Dockerfile .