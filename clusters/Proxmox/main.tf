locals {
  cluster = "Proxmox"
  name    = lower(terraform.workspace)
}

module "netbox" {
  source = "../../modules/netbox"
  name   = local.name
  token  = data.bitwarden-secrets_secret.secrets["netbox"].value
}

module "proxmox" {
  source      = "../../modules/proxmox"
  count       = local.cluster == module.netbox.configuration.cluster ? 1 : 0
  cpu         = module.netbox.configuration.cpu
  cpu_type    = module.netbox.configuration.platform.cpu
  description = module.netbox.configuration.description
  id          = module.netbox.configuration.id
  interface   = module.netbox.configuration.platform.interface
  iso         = module.netbox.configuration.platform.iso
  iso2        = module.netbox.configuration.platform.iso2
  memory      = module.netbox.configuration.memory
  name        = module.netbox.configuration.name
  networks    = module.netbox.configuration.nics
  node        = module.netbox.configuration.hypervisor
  os_type     = module.netbox.configuration.platform.type
  storage     = module.netbox.configuration.disks
  tags        = module.netbox.configuration.platform.tag
  type        = module.netbox.configuration.type
  uefi        = module.netbox.configuration.platform.uefi
}