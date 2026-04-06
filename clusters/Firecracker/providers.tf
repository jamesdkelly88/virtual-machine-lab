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
    system = {
      source  = "neuspaces/system"
      version = "0.5.0"
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

provider "system" {
  ssh {
    host     = module.netbox.configuration.hypervisor
    port     = "22"
    user     = data.bitwarden-secrets_secret.secrets["firecracker_user"].value
    password = data.bitwarden-secrets_secret.secrets["firecracker_password"].value
  }
  sudo = true
}

data "bitwarden-secrets_secret" "secrets" {
  for_each = tomap({
    netbox               = "18b5879e-acf6-4c4b-8e12-b31c007cac94"
    firecracker_user     = "a0b97856-60ce-4d03-80cc-b42400a7de35"
    firecracker_password = "74b1d9b4-7630-44a1-b619-b42400a7e9ac"
  })
  id = each.value
}