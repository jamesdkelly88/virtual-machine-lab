output "vm_id" {
  value = var.type == "lxc" ? -1 : proxmox_vm_qemu.this[0].vmid
}