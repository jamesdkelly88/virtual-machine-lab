resource "proxmox_vm_qemu" "this" {
  count = var.type == "lxc" ? 0 : 1

  agent   = 1
  balloon = 0
  bios    = var.uefi ? "ovmf" : "seabios"
  boot    = "order=${var.interface}0;ide1"
  cpu {
    cores   = var.cpu
    numa    = false
    sockets = 1
    type    = var.cpu_type
  }
  define_connection_info = false
  description            = "${var.description}\n\nManaged by Terraform"
  disk {
    backup = false
    iso    = local.proxmox_iso
    slot   = "ide1"
    type   = "cdrom"
  }
  dynamic "disk" {
    for_each = local.proxmox_iso2 != null ? toset([1]) : []
    content {
      backup = false
      iso    = local.proxmox_iso2
      slot   = "ide2"
      type   = "cdrom"
    }
  }
  dynamic "disk" {
    for_each = var.storage
    content {
      backup     = false
      emulatessd = disk.value.emulate_ssd
      format     = "raw"
      serial     = "${upper(var.name)}-D${disk.value.id}"
      size       = "${disk.value.size}G"
      slot       = "${var.interface}${disk.value.id}"
      storage    = disk.value.speed == "fast" ? "ssd" : "hdd"
      type       = "disk"
    }
  }
  dynamic "efidisk" {
    for_each = var.uefi ? toset([1]) : []
    content {
      efitype = "4m"
      storage = "hdd"
    }
  }
  force_create = false
  full_clone   = false
  hotplug      = "disk,network,usb"
  memory       = 1024 * var.memory
  name         = var.name
  dynamic "network" {
    for_each = var.networks
    content {
      bridge   = network.value.domain ? "vmbr2" : "vmbr1"
      firewall = false
      id       = network.value.id
      macaddr  = network.value.mac_address
      model    = var.interface == "virtio" || strcontains(var.iso2, "virtio") ? "virtio" : "e1000"
      tag      = 0
    }
  }
  onboot       = false
  protection   = false
  qemu_os      = var.os_type
  scsihw       = var.interface == "virtio" ? "virtio-scsi-single" : "lsi"
  startup      = ""
  tablet       = contains(["w2k","wxp"],var.os_type) ? false : true
  tags         = var.tags
  target_nodes = [var.node]
  dynamic "tpm_state" {
    for_each = var.os_type == "win11" ? toset([1]) : []
    content {
      storage = "hdd"
      version = "v2.0"
    }
  }
  vmid     = 100 + var.id
  vm_state = "stopped"

  lifecycle {
    ignore_changes = [
      disk[0].iso
    ]
  }

}