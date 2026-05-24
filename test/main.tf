resource "virtualbox_disk" "this" {
  provider = vbox
  for_each = { for disk in var.storage : disk.id => disk }
  file_path = "${ local.vdi_path }${ var.name}-${ each.value.id }.vdi"
  size      = 1024 * each.value.size
  format    = "VDI"
}

resource "virtualbox_vm" "this" {
  provider = vbox
  name = var.name
  ova_source = "blank.ova"
  memory = 1024.0 * var.memory
  status = "poweroff"
  # os_type = ""
  firmware = var.uefi ? "efi" : "bios"
  nested_hw_virt = true
  optical_disks = local.isos
  boot_order = ["disk", "dvd"]
  storage_controller {
    name = upper(var.interface)
    type = var.interface
  }
  dynamic "disk_attachment" {
    for_each = var.storage
    content {
      storage_controller = "${ var.interface}0"
      port = 0
      device = disk_attachment.value.id
      drive_type = "hdd"
      medium = virtualbox_disk.this[disk_attachment.value.id].file_path
      non_rotational = disk_attachment.value.emulate_ssd
    }
  }
}