### Provider Information
provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

module "example-single-linux-server" {
  source           = "../../../modules-vmware/module-compute"
  vmtemp           = var.vmtemplate
  instances        = var.instances_count
  vmname           = var.vm_name
  vmfolder         = var.vm_folder
  compute_cluster  = var.compute_cluster
  is_windows_image = var.is_windows_image
  cpu_number       = var.cpu_number
  ram_size         = var.ram_size
  network = {
    (var.vlan) = (var.ipv4_address)
  }
  ipv4submask       = var.ipv4submask
  vmdns             = var.vmdns
  dc                = var.dc
  datastore_cluster = var.datastore_cluster
}

### The Ansible inventory file
resource "local_file" "AnsibleInventory" {
  content = templatefile("inventory.tmpl",
    {
      linuxipv4-address = module.example-single-linux-server.Linux-ip
    }
  )
  filename = "inventory"
}

resource "null_resource" "run-ansible" {
   triggers = {
     always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "ansible-playbook ../../ansible/${var.stack}_playbook.yaml -i inventory --extra-vars 'ENVKEY=${var.environment}'"
  }
  depends_on = [module.example-single-linux-server]
}

terraform {
  backend "gcs" {
    bucket  = "tf-state"  
    prefix  = "terraform/state"
  }
}