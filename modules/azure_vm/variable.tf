variable "name" {
  description = "Name of the VM"
  type        = string
}

variable "location" {
  description = "Region of VM"
  type        = string
}

variable "network_interface_ids" {
  description = "Network interface for the VM"
  type        = list(string)
}

variable "resource_group_name" {
  description = "Resource group of VM"
  type        = string
}

variable "tags" {
  description = "(optional)"
  type        = map(string)
  default     = null
}


variable "vm_size" {
  description = "Machine type for VM "
  type        = string
}

variable "zones" {
  description = "Zones of the Region"
  type        = list(string)
  default     = null
}

variable "os_profile" {
  description = "OS profile configuration"
  type = set(object(
    {
      admin_password = string
      admin_username = string
      computer_name  = string
    }
  ))
  default = []
}


variable "storage_image_reference" {
  description = "Image information of VM"
  type = set(object(
    {
      offer     = string
      publisher = string
      sku       = string
      version   = string
    }
  ))
  default = []
}

variable "storage_os_disk" {
  description = "OS disk Configuration"
  type = set(object(
    {
      caching                   = string
      create_option             = string
      managed_disk_type         = string
      name                      = string
    }
  ))
}

variable "startup_script_filename" {
    description =   "Startup script to be run on VM"
    type        =   string
    default     =   ""
}