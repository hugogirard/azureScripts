# This script scale UP/DOWN the request unit of a cosmosDB container

[cmdletbinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$resourceGroup,    
    [Parameter(Mandatory=$true)]
    [string]$cosmosdbAccount,
    [Parameter(Mandatory=$true)]
    [string]$database,    
    [string]$container,    
    [int]$databaseThroughput, # 1 for database throughput otherwise no need this parameters    
    [Parameter(Mandatory=$true)]
    [int]$newRUs
)

$connectionName = "AzureRunAsConnection"

try {

    $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName

    "Logging in Azure..."
    Connect-AzAccount -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint


    if ($databaseThroughput -eq 1) {
        Write-Output "Update request units database level"
        $throughput = Get-AzCosmosDBSqlDatabaseThroughput -ResourceGroupName $resourceGroup `
                      -AccountName $cosmosdbAccount -Name $database
    } else {
        Write-Output "Update request units container level"
        $throughput = Get-AzCosmosDBSqlContainerThroughput -ResourceGroupName $resourceGroup `
        -AccountName $cosmosdbAccount -DatabaseName $database -Name $container
    }
    
    $currentRUs = $throughput.Throughput
    $minimumRUs = $throughput.MinimumThroughput
    
    Write-Output "Current throughput is $currentRUs. Minimum allowed throughput is $minimumRUs."
    
    if ([int]$newRUs -lt [int]$minimumRUs) {
        Write-Output "Requested new throughput of $newRUs is less than minimum allowed throughput of $minimumRUs."
        Write-Output "Using minimum allowed throughput of $minimumRUs instead."
        $newRUs = $minimumRUs
    }
    
    if ([int]$newRUs -eq [int]$currentRUs) {
        Write-Output "New throughput is the same as current throughput. No change needed."
    }
    else {
        Write-Output "Updating throughput to $newRUs."
        
        if ($databaseThroughput -eq 1) {
            Update-AzCosmosDBSqlDatabaseThroughput -ResourceGroupName $resourceGroup `
            -AccountName $cosmosdbAccount -Name $database `
            -Throughput $newRUs
        } else {
            Update-AzCosmosDBSqlContainerThroughput -ResourceGroupName $resourceGroup `
            -AccountName $cosmosdbAccount -DatabaseName $database `
            -Name $container -Throughput $newRUs
        }
    }
}
catch {
    if (!$servicePrincipalConnection)
    {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    } else{
        Write-Error -Message $_.Exception
        throw $_.Exception
    }    
}

