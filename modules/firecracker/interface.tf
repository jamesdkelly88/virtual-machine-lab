variable "cpu" {
  description = "Number of vCPUs to allocate to the virtual machine"
  type        = number
  validation {
    condition     = var.cpu == floor(var.cpu)
    error_message = "Value must be a whole number"
  }
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