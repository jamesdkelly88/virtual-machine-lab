variable "cpu" {
  description = "Number of vCPUs to allocate to the virtual machine"
  type        = number
  validation {
    condition     = var.cpu == floor(var.cpu)
    error_message = "Value must be a whole number"
  }
}
variable "cpu_type" {
  description = "Type of CPU to emulate"
  type        = string
}
variable "description" {
  description = "Summary of the VM's intended usage"
  type        = string
}
variable "id" {
  description = "ID number of the virtual machine. Must be between 0 and 254"
  type        = number
  validation {
    condition     = var.id >= 0 && var.id <= 254
    error_message = "Value must be between 0 and 254"
  }
}
variable "iso" {
  description = "Filename of ISO to attach to VM"
  type        = string
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
variable "node" {
  description = "Proxmox node to host virtual machine"
  type        = string
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
variable "tags" {
  description = "Comma separated list of tags for VM"
  type        = string
}
variable "type" {
  description = "Proxmox OS Type"
  type        = string
}
variable "uefi" {
  description = "Use modern UEFI firmware instead of legacy BIOS"
  type        = bool
}
variable "interface" {
  description = "Interface type"
  type        = string
}