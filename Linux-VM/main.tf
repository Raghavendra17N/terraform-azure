module "azure_vm"   {

    source                      =   "./modules/azure_vm"
    name                        =   "azure-linux-vm"
    location                    =   "East US 2"
    resource_group_name         =   "Product_Zero_DevOps"
    network_interface_ids       =   "product-zero947"
    vm_size                     =   "Standard_B2s"
    startup_script_filename     =   "startup_script.sh"
    os_profile                  =   var.os_profile
    storage_image_reference     =   var.storage_image_reference
    storage_os_disk             =   var.storage_os_disk
}
