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
    host     = "vm38" # TODO: netbox hypervisor
    port     = "22"
    user     = "terraform" # TODO: nitwarden secret
    password = "terraform" # TODO: nitwarden secret
  }
  sudo = true
}

data "bitwarden-secrets_secret" "secrets" {
  for_each = tomap({
    netbox           = "18b5879e-acf6-4c4b-8e12-b31c007cac94"
  })
  id = each.value
}