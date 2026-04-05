locals {
  cluster = "Firecracker"
  name    = lower(terraform.workspace)
}

module "netbox" {
  source = "../../modules/netbox"
  name   = local.name
  token  = data.bitwarden-secrets_secret.secrets["netbox"].value
}

module "firecracker" {
  source      = "../../modules/firecracker"
  count       = local.cluster == module.netbox.configuration.cluster ? 1 : 0
  cpu         = module.netbox.configuration.cpu
  description = module.netbox.configuration.description
  id          = module.netbox.configuration.id
  memory      = module.netbox.configuration.memory
  name        = module.netbox.configuration.name
  networks    = module.netbox.configuration.nics
  os          = lower(replace(module.netbox.configuration.platform.name," ","-"))
  storage     = module.netbox.configuration.disks
}