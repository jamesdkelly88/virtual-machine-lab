resource "virtualbox_disk" "this" {
  provider = vbox
  for_each = { for disk in var.storage : disk.id => disk }
  file_path = "${ local.vm_path }${ var.name }-${ each.value.id }.vdi"
  size      = 1024 * each.value.size
  format    = "VDI"
}

resource "random_uuid" "iso" {
  for_each = toset(local.isos)
}

resource "random_uuid" "vm" {
}

resource "local_file" "vbox" {
  content  = templatefile(
    "${path.module}/vbox.tpl", {
      controller_flags = local.controller_flags[local.interface]
      controller_name = local.controller_name[local.interface]
      controller_ports = local.controller_ports[local.interface]
      controller_type = local.controller_type[local.interface]
      cpu = var.cpu
      disks = join("\n",local.disk_xml)
      disk_attach = join("\n",local.controller_attach)
      ide_attach = join("\n",local.ide_attach)
      isos = join("\n",local.iso_xml)
      iso_ports = local.iso_port + 2
      machine_guid = random_uuid.vm.result
      memory = var.memory * 1024
      name = var.name
      nics = join("\n",local.nic_xml)
      os_type = local.os_map[var.os_type]
      uefi = var.uefi ? " type=\"EFI\"" : ""
    }
  )
  filename = "${ local.vm_path }${ var.name }.vbox"
}

# resource "virtualbox_vm" "this" {
#   provider = vbox
#   name = var.name
#   ova_source = "blank.ova"
#   memory = 1024.0 * var.memory
#   status = "poweroff"
#   # os_type = ""
#   firmware = var.uefi ? "efi" : "bios"
#   nested_hw_virt = true
#   optical_disks = local.isos
#   boot_order = ["disk", "dvd"]
#   storage_controller {
#     name = upper(var.interface)
#     type = var.interface
#   }
#   dynamic "disk_attachment" {
#     for_each = var.storage
#     content {
#       storage_controller = "${ var.interface}0"
#       port = 0
#       device = disk_attachment.value.id
#       drive_type = "hdd"
#       medium = virtualbox_disk.this[disk_attachment.value.id].file_path
#       non_rotational = disk_attachment.value.emulate_ssd
#     }
#   }
# }