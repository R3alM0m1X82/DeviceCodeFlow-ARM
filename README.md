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
- An **Azure AD tenant** (with Device Code Flow allowed)
- A registered **Azure AD app** with:
  - `Device Code Flow` enabled
  - `https://management.azure.com/.default` delegated permission

---

## 🚀 Usage

### 1️⃣ Clone the repository
```powershell
git clone https://github.com/<your-repo>/DeviceCodeFlow-ARM.git
cd DeviceCodeFlow-ARM
