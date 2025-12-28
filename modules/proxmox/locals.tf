locals {
  proxmox_iso  = var.iso == "" ? null : "iso:iso/${var.iso}"
  proxmox_iso2 = var.iso2 == "" ? null : "iso:iso/${var.iso2}"
}