variable "cpu" {
  description = "Number of vCPUs to allocate to the virtual machine"
  type        = number
  validation {
    condition     = var.cpu == floor(var.cpu)
    error_message = "Value must be a whole number"
  }
}
variable "interface" {
  description = "Interface type"
  type        = string

  validation {
    condition = contains(["ide", "sata", "scsi", "virtio"], var.interface)
    error_message = "Invalid interface, can be ide, sata, scsi or virtio"
  }
}
variable "iso" {
  description = "Filename of ISO to attach to VM"
  type        = string
  default     = "none"
}
variable "iso2" {
  description = "Filename of additional ISO to attach to VM (optional)"
  type        = string
  default     = "none"
}
variable "memory" {
  description = "Amount of memory to allocate to the virtual machine, in GB"
  type        = number
  validation {
    condition     = var.memory > 0
    error_message = "Value must be > 0"
  }
}
variable "name" {
  description = "Name of the VM"
  type        = string
}
variable "networks" {
  description = "Network interface definitions"
  type = list(object({
    id          = number
    mac_address = string
    name        = string
    domain      = bool
  }))
}
variable "os_type" {
  description = "Operating system type"
  type        = string
}
variable "storage" {
  description = "The disks to allocate to the virtual machine"
  type = list(object({
    id          = number
    size        = number
    mount_point = string
    speed       = string
    emulate_ssd = bool
  }))
}
variable "uefi" {
  description = "Use modern UEFI firmware instead of legacy BIOS"
  type        = bool
}
