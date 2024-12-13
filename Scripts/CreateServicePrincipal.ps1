# Define the required variables
$ServicePrincipalName = "terraform-sp"   # Replace with your desired service principal name
$RoleDefinitionName = "Contributor"                 # Replace with the desired role (e.g., "Contributor", "Owner", etc.)
$ManagementGroupId = "9af24fde-595c-4c76-a9cd-ca27c1ee7663"        # Replace with your Azure Management Group ID
 
# Create the Service Principal
$sp = (az ad sp create-for-rbac --name $ServicePrincipalName --role $RoleDefinitionName --scopes /providers/Microsoft.Management/managementGroups/$ManagementGroupId) | ConvertFrom-Json
 
# Set environment variables for the Service Principal
$env:ARM_CLIENT_ID = $sp.appId
$env:ARM_CLIENT_SECRET = $sp.password
$env:ARM_TENANT_ID = $sp.tenant
 
# Output the Service Principal details
Write-Host "Service Principal App ID: $($sp.appId)"
Write-Host "Service Principal Password: $($sp.password)"
Write-Host "Tenant ID: $($sp.tenant)"
 
# Log in to Azure with the Service Principal
az login --service-principal -u "$env:ARM_CLIENT_ID" -p "$env:ARM_CLIENT_SECRET" --tenant "$env:ARM_TENANT_ID"
 
# Confirm successful login
Write-Host "Logged in to Azure with Service Principal."