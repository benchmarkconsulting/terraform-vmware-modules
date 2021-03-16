provider "vsphere" {
  user           = var.vsphere-user
  password       = var.vsphere-password
  vsphere_server = var.vsphere-server
  allow_unverified_ssl = true
}

module "compute" {
  source            = "source = "git::https://github.com/benchmarkconsulting/vmware-terraform-modules//compute""
  vmtemp            = var.vmtemplate
  instances         = var.instances_count
  vmname            = var.vm_name
  vmfolder          = var.vm_folder
  compute_cluster   = var.compute_cluster
  windows           = var.windows
  cpu_number        = var.cpu_number
  ram_size          = var.ram_size
  network           = {
    (var.vlan) = (var.ipv4_address) # To use DHCP create Empty list ["",""]
  }
  vmgateway         = var.vmgateway[var.vlan]
  ipv4submask       = var.ipv4submask
  ignored_guest_ips = [""]
  vmdns             = [""]
  dc                = ""
  datastore_cluster = ""
}

### The Ansible inventory file
resource "local_file" "AnsibleInventory" {
  content = templatefile("inventory.tmpl",
  {
    winipv4-address = module.compute.Windows-ip
    linipv4-address = module.compute.Linux-ip
  }
  )
  filename = "inventory"
}

resource "null_resource" "run-ansible" {
  provisioner "local-exec" {
     command = "ansible-playbook  ../ansible/${var.stack}_playbook.yaml -i inventory"
  }
  depends_on = [module.compute]
}