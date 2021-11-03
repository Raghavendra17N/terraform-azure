variable "storage_account_name" {

    description                     =   "Name of the Storage account"
    type                            =   string
}

variable "container_name" {
    description                     =   "Name of the storage container"
    type                            =   string
}

variable "azure_subscription_id" {
    description                     =   "azure_subscription_id"
    type                            =   string 
}

variable "azure_tenant_id" {
    description                     =   "azure_tenant_id"
    type                            =   string 
}

variable "azure_client_id" {
    description                     =   "azure_client_id"
    type                            =   string 
}

variable "azure_client_secret" {
    description                     =   "azure_client_secret"
    type                            =   string 
}


variable "os_profile" {

  description = "OS profile configuration"
  type = set(object(
    {
      admin_password                = string
      admin_username                = string
      computer_name                 = string
    }
  ))
  default = [{

        admin_username              =   "tfadmin"
        admin_password              =   "admin123"
        computer_name               =   "windows_vm"
  }]
}

variable "storage_image_reference" {

    description =   "Image information of VM"
      type                          = set(object(
    {
      offer                         = string
      publisher                     = string
      sku                           = string
      version                       = string
    }
  ))
  default       =   [{
      offer                         = "WindowsServer"
      sku                           = "2019-Datacenter"
      version                       = "latest"
      publisher                     = "MicrosoftWindowsServer"
  }]
}

variable "storage_os_disk"      {

      description = "OS disk Configuration"
        type = set(object(
    {
      caching                       = string
      create_option                 = string
      managed_disk_type             = string
      name                          = string
    }
  ))
  default       =   [{

      name                          = "os_disk"
      caching                       = "ReadWrite"
      create_option                 = "FromImage"
      managed_disk_type             = "Standard_LRS"
  }]
}