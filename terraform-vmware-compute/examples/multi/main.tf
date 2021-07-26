
provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

module "web" {
  source           = "../../../modules-vmware/module-compute"
  vmtemp           = var.web_vmtemplate
  instances        = var.web_instances_count
  vmname           = var.web_vm_name
  vmfolder         = var.web_vm_folder
  compute_cluster  = var.web_compute_cluster
  is_windows_image = var.web_is_windows_image
  cpu_number       = var.web_cpu_number
  ram_size         = var.web_ram_size
  network = {
    (var.vlan) = (var.web_ipv4_address)
  }
  ipv4submask       = var.web_ipv4submask
  vmdns             = var.web_vmdns
  dc                = var.web_dc
  datastore_cluster = var.web_datastore_cluster
  disk_size_gb      = var.web_disk_size_gb
}

module "app" {
  source           = "../../../modules-vmware/module-compute"
  vmtemp           = var.app_vmtemplate
  instances        = var.app_instances_count
  vmname           = var.app_vm_name
  vmfolder         = var.app_vm_folder
  compute_cluster  = var.app_compute_cluster
  is_windows_image = var.app_is_windows_image
  cpu_number       = var.app_cpu_number
  ram_size         = var.app_ram_size
  network = {
    (var.vlan) = (var.app_ipv4_address) # To use DHCP create Empty list ["",""]
  }
  ipv4submask       = var.app_ipv4submask
  vmdns             = var.app_vmdns
  dc                = var.app_dc
  datastore_cluster = var.app_datastore_cluster
  disk_size_gb      = var.app_disk_size_gb
}

# Create the local ansible inventory file
resource "local_file" "AnsibleInventory" {
  content = templatefile("inventory.tmpl",
    {
      #configures the inventory file to set up the web server(s)
      web-address = module.web.Linux-ip
      #configures the inventory file for the app server(s)
      app-address = module.app.Linux-ip
      ansible_user = var.ansible_user
      ansible_password = var.ansible_password
    
    }
  )
  filename = "inventory"
}

resource "null_resource" "run-ansible" {
  triggers = {
      always_run = timestamp()
    }
  provisioner "local-exec" {
    command = "ansible-playbook ../../ansible/${var.stack}_playbook.yaml -i inventory --extra-vars 'ENVKEY=${var.envkey}'"
  }

  depends_on = [module.web,module.app]
}

terraform {
  backend "gcs" {
    bucket  = "tf-state"  
    prefix  = "terraform/state"
  }
}