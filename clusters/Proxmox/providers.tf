terraform {

  cloud {
    organization = "jdkhomelab-vm"
    hostname     = "app.terraform.io"
  }

  required_version = "~> 1.2"

  required_providers {
    bitwarden-secrets = {
      source  = "bitwarden/bitwarden-secrets"
      version = "0.5.4-pre"
    }
    netbox = {
      source  = "e-breuninger/netbox"
      version = "~> 5.0"
    }
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc03"
    }
  }
}

provider "bitwarden-secrets" {
  api_url      = "https://api.bitwarden.com"
  identity_url = "https://identity.bitwarden.com"
}

provider "netbox" {
  server_url           = "https://netbox2.jk88.duckdns.org"
  allow_insecure_https = true
  request_timeout      = 120
  api_token            = data.bitwarden-secrets_secret.secrets["netbox"].value
}

provider "proxmox" {
  pm_api_url      = "https://${module.netbox.configuration.hypervisor}:8006/api2/json"
  pm_password     = data.bitwarden-secrets_secret.secrets["proxmox_password"].value
  pm_tls_insecure = true
  pm_user         = data.bitwarden-secrets_secret.secrets["proxmox_user"].value

}

data "bitwarden-secrets_secret" "secrets" {
  for_each = tomap({
    netbox           = "18b5879e-acf6-4c4b-8e12-b31c007cac94"
    proxmox_user     = "00118f7b-7078-4a05-aa25-b3a501004392"
    proxmox_password = "ccd8e4f7-68f6-42d4-8677-b3a501005297"
  })
  id = each.value
}