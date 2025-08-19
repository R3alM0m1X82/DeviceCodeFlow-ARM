<#
.SYNOPSIS
    Device Code Flow authentication for Azure Resource Manager (ARM).

.DESCRIPTION
    This PowerShell script demonstrates how to use OAuth 2.0 Device Code Flow
    to obtain an access token and refresh token from Azure AD,
    and use the token against the Azure Resource Manager (ARM) API.

.AUTHOR
    R3alM0m1X82

.VERSION
    1.0

.DATE
    2025-08-19
#>

# ========================
# === CONFIG VARIABLES ===
# ========================

# Replace with your Azure AD tenant ID (GUID). Avoid using "common" in labs.
$tenantId  = "<your-tenant-id>"

# Client ID of the registered application (public client, Device Code Flow enabled)
$clientId  = "9ba1a5c7-f17a-4de9-a1f1-6178c8d51223"

# Scope required for ARM API
$scope     = "https://management.azure.com/.default offline_access"

# ========================
# === STEP 1: DEVICE CODE REQUEST ===
# ========================

$body = @{
    client_id = $clientId
    scope     = $scope
}

$deviceCodeResponse = Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/devicecode" -Body $body

# Show user instructions (URL + device code)
Write-Host $deviceCodeResponse.message -ForegroundColor Yellow

# ========================
# === STEP 2: TOKEN POLLING ===
# ========================

$tokenUri = "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token"
$tokenResponse = $null

do {
    Start-Sleep -Seconds $deviceCodeResponse.interval
    try {
        $tokenResponse = Invoke-RestMethod -Method Post -Uri $tokenUri -Body @{
            grant_type  = "urn:ietf:params:oauth:grant-type:device_code"
            client_id   = $clientId
            device_code = $deviceCodeResponse.device_code
        }
    } catch {
        # Keep polling until user completes authentication (authorization_pending errors are expected)
    }
} while (-not $tokenResponse)

# Extract tokens
$accessToken  = $tokenResponse.access_token
$refreshToken = $tokenResponse.refresh_token

Write-Host "`n✅ Access Token obtained successfully!" -ForegroundColor Green

# ========================
# === STEP 3: CALL ARM API ===
# ========================

# Example: list subscriptions
$headers = @{ Authorization = "Bearer $accessToken" }
Invoke-RestMethod -Uri "https://management.azure.com/subscriptions?api-version=2020-01-01" -Headers $headers

# ========================
# === STEP 4: REFRESH TOKEN (OPTIONAL) ===
# ========================

$refreshBody = @{
    client_id     = $clientId
    scope         = "https://management.azure.com/.default"
    refresh_token = $refreshToken
    grant_type    = "refresh_token"
}

$refreshedToken = Invoke-RestMethod -Method Post -Uri $tokenUri -Body $refreshBody
$newAccessToken = $refreshedToken.access_token

Write-Host "`n🔄 New Access Token obtained via refresh token." -ForegroundColor Cyan
