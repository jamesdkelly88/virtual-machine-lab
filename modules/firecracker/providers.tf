terraform {
  required_providers {
    system = {
      source  = "neuspaces/system"
      version = "0.5.0"
    }
  }
}

provider "system" {
  ssh {
    host     = "vm38"
    port     = "22"
    user     = "terraform"
    password = "terraform"
  }
  sudo = true
}