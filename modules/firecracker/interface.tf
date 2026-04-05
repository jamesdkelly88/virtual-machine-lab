variable "cpu" {
  description = "Number of vCPUs to allocate to the virtual machine"
  type        = number
  validation {
    condition     = var.cpu == floor(var.cpu)
    error_message = "Value must be a whole number"
  }
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
variable "os" {
  description = "OS base image"
  type        = string
}

variable "storage" {
  description = "The disks to allocate to the virtual machine"
  type = list(object({
    # id          = number
    size = number
    # mount_point = string
    # speed       = string
    # emulate_ssd = bool
  }))
}