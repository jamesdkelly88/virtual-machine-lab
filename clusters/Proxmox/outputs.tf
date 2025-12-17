output "cluster" {
  value = local.cluster == module.netbox.configuration.cluster ? local.cluster : null
}
output "description" {
  value = local.cluster == module.netbox.configuration.cluster ? module.netbox.configuration.description : null
}
output "id" {
  value = local.cluster == module.netbox.configuration.cluster ? module.proxmox[0].vm_id : null
}
output "name" {
  value = local.cluster == module.netbox.configuration.cluster ? module.netbox.configuration.name : null
}
output "platform" {
  value = local.cluster == module.netbox.configuration.cluster ? module.netbox.configuration.platform.name : null
}
output "hypervisor" {
  value = local.cluster == module.netbox.configuration.cluster ? module.netbox.configuration.hypervisor : null
}