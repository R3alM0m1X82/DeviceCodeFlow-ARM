<#
.SYNOPSIS
Device Code Flow to obtain Microsoft Graph token using Azure PowerShell ClientId.
This token can be used to connect to Azure AD via Connect-AzAccount for delegated operations (e.g., reset password in AU).

.AUTHOR
R3alM0m1X82

.VERSION
1.0 - 2025-08-19

.NOTES
This script uses the Azure PowerShell first-party ClientId (1950a258-227b-4e31-a9cf-717495945fc2)
to obtain a delegated token for Graph with offline_access.
#>

# Azure PowerShell ClientId (first-party)
$ClientId = "1950a258-227b-4e31-a9cf-717495945fc2"

# Scope for Microsoft Graph - use only .default + offline_access
$GraphScope = "https://graph.microsoft.com/.default offline_access"

# Tenant ID (replace with your tenant)
$TenantId = "<YOUR_TENANT_ID>"

# Device Code Flow request body
$body = @{
    client_id = $ClientId
    scope     = $GraphScope
}

# Request device code from Microsoft identity platform
$authResponse = Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$TenantId/oauth2/v2.0/devicecode" -Body $body -UseBasicParsing
Write-Host "Please authenticate using the device code below:"
Write-Host $authResponse.message

# Poll for token until user authenticates
$tokenBody = @{
    grant_type = "urn:ietf:params:oauth:grant-type:device_code"
    client_id = $ClientId
    device_code = $authResponse.device_code
}

do {
    Start-Sleep -Seconds $authResponse.interval
    try {
        $tokenResponse = Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$TenantId/oauth2/v2.0/token" -Body $tokenBody -UseBasicParsing -ErrorAction Stop
    } catch {
        $null = $_
    }
} until ($tokenResponse.access_token)

Write-Host "`nToken acquired successfully!"
$GraphToken = $tokenResponse.access_token

# Connect to Azure using Graph token
Connect-AzAccount -AccountId "<HELPDESK_USER_UPN>" -MicrosoftGraphAccessToken $GraphToken -AccessToken $GraphToken -Tenant $TenantId

Write-Host "`nConnected to Azure with Graph token. Ready to manage users (e.g., reset password in AU)."
