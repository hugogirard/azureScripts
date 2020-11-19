# This script compile the bicep template and deploy it
param(
    [string]$resourceGroup = 'aci-demo-agent-rg',
    [string]$location = 'eastus',
    [string]$pat,
    [string]$org='https://dev.azure.com/hugirardsandbox/'
)


$id = az group create -n $resourceGroup -l $location --query id

$tmp = $id -split '/'
$suffix = $tmp[2] -replace "-",""
$acrname = "acr$suffix"

# Create an ACR, when ACI run in a VNET it doesn't support managed identity for now
az acr create -n $acrname -g $resourceGroup --admin-enabled --sku Standard

# Login to ACR
az acr login -n $acrname

# Pull the agent and push it using ACR task
az acr build --image dockeragent:latest --registry $acrname --file Dockerfile .

$result = az acr credential show -n $acrname -g $resourceGroup | ConvertFrom-Json
$username =  $result.username
$password = $result.passwords[0].value
$server = "$acrname.azurecr.io"
$imagename = "$acrname.azurecr.io/dockeragent:latest"

az container create -g $resourceGroup --name 'devopsagent' --image $imagename --cpu 1 --memory 1.5 --registry-login-server $server --registry-username $username --registry-password $password `
--environment-variables AZP_URL=$org AZP_TOKEN=$pat AZP_AGENT_NAME=aciagent AZP_POOL=AciPool --ports 80 443

