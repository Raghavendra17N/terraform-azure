data "template_file" "startup_script"{
        template                                =       file("${var.startup_script_filename}")
}


resource "azurerm_virtual_machine" "azure_vm" {

        name                                    =       var.name
        location                                =       var.location
        network_interface_ids                   =       var.network_interface_ids
        resource_group_name                     =       var.resource_group_name
        tags                                    =       var.tags
        vm_size                                 =       var.vm_size
        zones                                   =       var.zones
        
        dynamic "storage_image_referance" {

            for_each                            =       var.storage_image_referance
            content     {

                publisher                       =       storage_image_referance.vaule["publisher"]
                offer                           =       storage_image_referance.vaule["offer"]
                sku                             =       storage_image_referance.vaule["sku"]
                version                         =       storage_image_referance.vaule["version"]
            }
        }

        dynamic "storage_os_disk" {

            for_each                            =       var.storage_os_disk
            content     {
                
                name                            =       storage_os_disk.vaule["name"]
                create_option                   =       storage_os_disk.vaule["create_option"]
                caching                         =       storage_os_disk.vaule["caching"]
                managed_disk_type               =       storage_os_disk.vaule["managed_disk_type"]
            }
        }

        os_profile_linux_config  {
            
            disable_password_authentication     =       false
        }

        dynamic "os_profile"  {

            for_each                            =       var.os_profile
            content           {

                computer_name                   =       os_profile.vaule["computer_name"]
                admin_username                  =       os_profile.value["admin_username"]
                admin_password                  =       os_profile.value["admin_password"]
                custom_data                     =       base64encode(data.template_file.startup_script.rendered)           
            }

        }

}
