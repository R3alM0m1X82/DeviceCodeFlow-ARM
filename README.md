# 🔑 Azure Device Code Flow for ARM API

This repository contains a PowerShell script that demonstrates how to use **OAuth 2.0 Device Code Flow** with Azure Active Directory to obtain an access token and call the **Azure Resource Manager (ARM)** API.

---

## ✨ Features
- 🔐 Authenticate to Azure using **Device Code Flow**
- 📥 Retrieve **access token** and **refresh token**
- ☁️ Call Azure Resource Manager (`/subscriptions`) with the access token
- ♻️ Refresh tokens without re-authenticating

---

## 🛠 Requirements
- Windows PowerShell **5.1** or PowerShell **7+**
- An **Azure AD tenant**
- A registered **Azure AD application** (public client) with:
  - **Device Code Flow** allowed
  - API permissions for **ARM** via the scope: `https://management.azure.com/.default`

> ℹ️ The script uses **v2.0** endpoints and requests `offline_access` to receive a refresh token.

---

## ⚙️ Setup
1. **Clone the repository**
   ```powershell
   git clone https://github.com/<your-repo>/DeviceCodeFlow-ARM.git
   cd DeviceCodeFlow-ARM
   ```

2. **Configure your Tenant ID**
   Open the script and set:
   ```powershell
   $tenantId = "<your-tenant-id>"
   ```

3. *(Optional)* **Check the Client ID**
   The script uses:
   ```powershell
   $clientId = "9ba1a5c7-f17a-4de9-a1f1-6178c8d51223"
   ```
   Replace it with your app’s client ID if needed.

---

## 🚀 Usage
```powershell
.\DeviceCodeFlow-ARM.ps1
```

Follow the console instructions:
- Open the shown browser URL
- Enter the **device code**
- Approve the login

On success, the script will call ARM (`/subscriptions`) and then refresh the token once.

---

## 🧩 Configuration Details
- **Tenant**: Prefer a specific tenant ID instead of `common`, especially in lab scenarios.
- **Scopes**: The script requests  
  ```
  https://management.azure.com/.default offline_access
  ```
  which enables ARM calls and issues a refresh token.
- **Endpoints**: Tokens are requested from  
  `https://login.microsoftonline.com/<tenant-id>/oauth2/v2.0/*`

---

## 🧪 Example Output
```text
To sign in, use a web browser to open the page https://microsoft.com/devicelogin
and enter the code ABCDEFG123 to authenticate.
Access Token obtained successfully.
New Access Token obtained via refresh token.
```

---

## 🧯 Troubleshooting
- **AADSTS900144** – *The request body must contain the following parameter: 'refresh_token'.*  
  Ensure `$refreshToken` is initialized from the **device_code** token response before using the `refresh_token` grant.

- **authorization_pending / slow_down** during polling  
  These are expected while waiting for the user to complete sign-in. The script keeps polling with the interval provided by the service.

- **invalid_scope**  
  Make sure the initial device code request includes `https://management.azure.com/.default offline_access`.

- **invalid_grant**  
  Device code expired; rerun the script and complete sign-in in time.

---

## 👤 Author
- **R3alM0m1X82**  
- Version: **1.0**  
- Date: **2025-08-19**

---

## 📜 License
MIT — feel free to use it in demos, labs, or internal tooling.
