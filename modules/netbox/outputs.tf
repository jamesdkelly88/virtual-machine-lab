output "configuration" {
  value = {
    name        = var.name
    cluster     = data.netbox_cluster.lookup.name
    cpu         = local.vm.vcpus
    description = local.vm.description
    disks       = local.disks
    hypervisor  = data.netbox_devices.lookup.devices[0].name
    id          = tonumber(replace(var.name, "vm", ""))
    memory      = local.vm.memory_mb / 1000.0
    nics        = local.nics
    platform    = lookup(local.platforms, local.vm.platform_slug, local.platforms["unknown"])
    swap        = coalesce(local.vm.custom_fields["swap"], 0)
    type        = tostring(local.vm.role_id) == data.netbox_device_role.lxc.id ? "lxc" : "vm"
  }
}