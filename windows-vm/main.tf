module "azure_vm"   {

    source                      =   "./modules/azure_vm"
    name                        =   "azure-windows-vm"
    location                    =   "East US 2"
    resource_group_name         =   "Product_Zero_DevOps"
    network_interface_ids       =   "product-zero947"
    vm_size                     =   "Standard_B2s"
    os_profile                  =   var.os_profile
    storage_image_reference     =   var.storage_image_reference
    storage_os_disk             =   var.storage_os_disk
}

resource "azurerm_virtual_machine_extension" "example" {
  name                          = module.azure_vm.name
  virtual_machine_id            = module.azure_vm.azure_vm_id
  publisher                     = "Microsoft.Azure.Extensions"
  type                          = "CustomScript"
  type_handler_version          = "2.0"

  settings = <<SETTINGS
    {
        "commandToExecute": "powershell Install-WindowsFeature NET-Framework-Core"
    }
SETTINGS


  tags = {
    environment = "Production"
  }
}