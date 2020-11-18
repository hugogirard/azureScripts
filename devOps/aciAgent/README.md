# What this does

This provide a self hosted agent running in Azure Container Instance, the advantage of doing this are the following

<ul>
<li>It does not use public IP’s. It doesn’t need one, as the Azure DevOps agent initiates the communication to the service.
</li>
<li>It does not have any exposed ports. There’s no need for publishing anything.</li>
<li>Logging in to these containers is not possible (console and network access is not available) – only the configuration script’s outputs can be read, as these are printed to the console.</li>
<li>There’s no need to maintain a VNET or any other infrastructure pieces, as these ACI instances can exist on their own.</li>
<li>Has a lightweight footprint.</li>
<li>Can be provisioned very quickly: to fully configure a container instance with the required components takes 5-10 minutes.</li>
<li>Is immutable: it does not need patching/management. For version upgrades, the existing instances have to be deleted, and the new ones can easily be re-created by running the provision scripts again.</li>
</ul>

Here the official [documentation](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/docker?view=azure-devops)

To create a ready environment to test just use the main.json ARM template file.  This ARM template was created using Bicep.  ** AT THIS MOMENT BICEP IS NOT READY FOR PRODUCTION **

Once your image is created you will need to push it to an Azure Container Registry, there our official [documentation]

** IMPORTANT, this sample is for Linux Container, the Microsoft doc show how to use Windows Container **

`
az acr build --image dockeragent:latest --registry $acr --file Dockerfile .
`

Now the image is pushed in the ACR

This sample was created following two interesting article

[First one](https://blog.jcorioland.io/archives/2020/06/08/terraform-azurerm-azure-container-instance-devops-agent.html)

[Second one](https://devblogs.microsoft.com/devops/azure-devops-agents-on-azure-container-instances-aci/)