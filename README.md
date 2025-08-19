# Azure Device Code Flow for ARM API

This repository contains a PowerShell script that demonstrates how to use **OAuth 2.0 Device Code Flow** with Azure Active Directory to obtain an access token and call the **Azure Resource Manager (ARM)** API.

---

## 📌 Features
- Request a device code and prompt the user to authenticate.
- Poll the token endpoint until authentication is complete.
- Retrieve **access token** and **refresh token**.
- Call ARM API (`/subscriptions`) with the access token.
- Refresh the access token using the refresh token.

---

## 🚀 Usage

1. Clone the repository:
   ```powershell
   git clone https://github.com/<your-repo>/DeviceCodeFlow-ARM.git
