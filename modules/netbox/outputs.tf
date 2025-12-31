output "configuration" {
  value = {
    name        = var.name
    cluster     = data.netbox_cluster.lookup.name
    cpu         = local.vm.vcpus
    description = local.vm.description
    disks       = local.disks
    hypervisor  = local.vm.device_name
    id          = tonumber(replace(var.name, "vm", ""))
    memory      = local.vm.memory_mb / 1000.0
    nics        = local.nics
    platform    = {
      name      = local.platform.display
      tag       = local.platform.slug
      type      = local.platform.custom_fields.os_type
      iso       = coalesce(local.platform.custom_fields.iso,"")
      iso2      = coalesce(local.platform.custom_fields.iso2,"")
      lxc_image = local.platform.custom_fields.lxc_image
      uefi      = local.platform.custom_fields.uefi == "y"
      interface = local.platform.custom_fields.interface
      cpu       = local.platform.custom_fields.cpu_type
    }
    swap        = coalesce(local.vm.custom_fields["swap"], 0)
    type        = tostring(local.vm.role_id) == data.netbox_device_role.lxc.id ? "lxc" : "vm"
  }
}