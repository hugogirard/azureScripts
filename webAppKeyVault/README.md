# Deploy Two Web App (Front-Back) and securing the Backend URL in Azure Keyvault accessible only within a VNET

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fhugogirard%2FazureScripts%2Fmaster%2FwebAppKeyVault%2Fbicep%2Fmain.json)

[![Visualize](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/visualizebutton.svg?sanitize=true)](http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fhugogirard%2FazureScripts%2Fmaster%2FwebAppKeyVault%2Fbicep%2Fmain.json)

## How to deploy

**Clone** this Git Repo first.

Click the big **Deploy to Azure button**, once this is done go to a terminal to the frontend folder.

Install the [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) and [Dotnet Core version 3.X](https://dotnet.microsoft.com/download)

Now open a terminal and do 

`
az login
`

Be sure you are on the subscription that you deployed all the previous resources.

To validate wich subscription you are using just do 

`
az account show
`

If is not the good one you can refer [here](https://docs.microsoft.com/en-us/cli/azure/account?view=azure-cli-latest)

Now go to the folder of the FrontEnd where you cloned the repository

`
azureScripts\webAppKeyVault\FrontEndWeb
`

Now you need to publish the app do this command

`
dotnet publish -o output -c Release
`

Now create a zip file, do to so enter the output folder and do this command.

### Bash
`
zip -r output.zip .
`
### PowerShell
`
Compress-Archive -Path * -DestinationPath output.zip
`

Next you just need to publish the frontend app to azure running this command

`
az webapp deployment source config-zip --resource-group <group-name> --name <app-name> --src output.zip
`

Repeat the same command for the backend that you will find in the folder **webAppKeyVault**.

Once is done go to Azure Portal and browse the URL of the frontend app, you should see some weather showing up.


