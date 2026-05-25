-- Create a user for the User-Assigned Identity
CREATE USER [id-laravel-app] FROM EXTERNAL PROVIDER;

-- Grant permissions
ALTER ROLE db_datareader ADD MEMBER [id-laravel-app];
ALTER ROLE db_datawriter ADD MEMBER [id-laravel-app];
ALTER ROLE db_ddladmin ADD MEMBER [id-laravel-app]; -- Required for 'php artisan migrate'


<!-- Don't guess the GUIDs. Use the Azure CLI to find the exact ID for any policy name: -->

az policy definition list --query "[?displayName=='Allowed locations'].{Name:name,Id:id}" --output table

# Infrastructure Environment Bootstrsap
az group create --name gradestar-admin-rg --location eastus
az storage account create --name gradestartfstate --resource-group gradestar-admin-rg --sku Standard_LRS
az storage container create --name tfstate --account-name gradestartfstate

# Import SSL Cert into keyvault
az keyvault certificate import \
    --vault-name "kv-policy-gov-production" \
    --name "gradestar-pfx" \
    --file "gradestar-origin.pfx" \
    --password "gradestar123"