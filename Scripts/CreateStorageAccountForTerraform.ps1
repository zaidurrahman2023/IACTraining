<#
.SYNOPSIS
Creates an Azure Storage Account and Container for Terraform state management with appropriate RBAC permissions.

.DESCRIPTION
This script creates a resource group, storage account, and container in Azure for storing Terraform state files.
It also assigns the necessary RBAC permissions to a specified service principal.

.PARAMETER ResourceGroupName
The name of the resource group to create. Default: "rg-terraform-state"

.PARAMETER StorageAccountName
The name of the storage account to create. Must be globally unique, 3-24 characters, lowercase letters and numbers only.
Default: "saterraformstate"

.PARAMETER Location
The Azure region where resources will be created. Default: "eastus"

.PARAMETER ContainerName
The name of the blob container to create. Default: "terraform-state"

.PARAMETER ServicePrincipalName
The display name of the existing service principal that will be granted access. Default: "sp-terraform-cpkcr"

.EXAMPLE
# Run with default parameters
.\CreateStorageAccountForTerraform.ps1

.EXAMPLE
# Run with custom parameters
.\CreateStorageAccountForTerraform.ps1 `
    -ResourceGroupName "rg-terraform-prod" `
    -StorageAccountName "saprodtfstate" `
    -Location "westus2" `
    -ContainerName "tfstate" `
    -ServicePrincipalName "sp-terraform-prod"

.NOTES
- Requires Azure CLI (az) to be installed and logged in
- Service Principal must exist before running this script
- Storage account name must be globally unique
#>

param(
    [string]$ResourceGroupName = "rg-terraform-state",
    [string]$StorageAccountName = "saterraformstate",
    [string]$Location = "eastus",
    [string]$ContainerName = "terraform-state",
    [string]$ServicePrincipalName = "sp-terraform-cpkcr"
)

# Validate storage account name
if ($StorageAccountName -notmatch "^[a-z0-9]{3,24}$") {
    throw "Storage account name must be 3-24 characters long and contain only lowercase letters and numbers."
}

# Login to Azure
Write-Output "Ensuring Azure CLI is logged in..."
az account show > $null
if ($LASTEXITCODE -ne 0) {
    az login
}

# Create the resource group
Write-Output "Creating resource group $ResourceGroupName in location $Location"
$result = az group create --name $ResourceGroupName --location $Location
Write-Output $result

# Create the storage account
Write-Output "Creating storage account $StorageAccountName in resource group $ResourceGroupName"
$result = az storage account create --resource-group $ResourceGroupName --name $StorageAccountName --sku Standard_LRS
Write-Output $result

# Create the container
Write-Output "Creating container $ContainerName in storage account $StorageAccountName"
$result = az storage container create --name $ContainerName --account-name $StorageAccountName
Write-Output $result

# Get the service principal ID
$spId = az ad sp list --display-name $ServicePrincipalName --query "[0].id" -o tsv

if ($spId) {
    # Get the storage account ID
    $storageAccountId = az storage account show --name $StorageAccountName --resource-group $ResourceGroupName --query "id" -o tsv
    
    # Assign Blob Data Contributor role to the service principal
    Write-Output "Assigning Blob Data Contributor role to service principal"
    $result = az role assignment create --assignee $spId `
        --role "Storage Blob Data Contributor" `
        --scope $storageAccountId
    Write-Output $result
} else {
    Write-Output "Warning: Service Principal '$ServicePrincipalName' not found. Please ensure it exists and run the role assignment manually."
}

Write-Output "Storage account $StorageAccountName created successfully"
