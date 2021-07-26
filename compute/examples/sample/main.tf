provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

module "web" {
  source              = "../../../modules-vmware/module-compute"
  vmtemp              = var.vmtemplate
  instances           = web_var.instances_count
  vmname              = web_var.vm_name
  vmfolder            = var.vm_folder
  compute_cluster     = var.compute_cluster
  is_windows_image    = var.is_windows_image
  cpu_number          = web_var.cpu_number
  ram_size            = web_var.ram_size
  network = {
    (var.vlan) = (var.web_ipv4_address) # To use DHCP create Empty list ["",""]
  }
  ipv4submask           = var.ipv4submask
  vmdns                 = var.vmdns
  dc                    = var.dc
  datastore_cluster     = var.datastore_cluster

  # OS disk size comes from the VMware template
  # If you need to increase OS disk size uncomment the line below and add the variable to the variables.tf and terraform.tfvars
  # disk_size_gb          = var.disk_size_gb

  # To add additional disks uncomment the lines below and add the variable to the variables.tf and terraform.tfvars
  # data_disk = {
  #  disk1 = {
  #    size_gb                   = var.data_disk_size_gb,
  #    thin_provisioned          = true,
  #  },
  #}
}

# Create the local ansible inventory file
resource "local_file" "AnsibleInventory" {
  content = templatefile("inventory.tmpl",
    {
      windows-address = module.win_template.Windows-ip
      web-linux-address = module.web.Linux-ip
    }
  )
  filename = "inventory"
}

resource "null_resource" "run-ansible-destroy-web" {
  for_each = toset(module.web.Linux-VM)
  triggers = {
    vmname = each.key
    ansible_user = var.ansible_user
    ansible_password = var.ansible_password
  }
  provisioner "local-exec" {
    command = "ansible-playbook ../../ansible/destroy_playbook.yaml -i 10.10.102.20, --extra-vars 'vmname=${self.triggers.vmname} ansible_user=${self.triggers.ansible_user} ansible_password=${self.triggers.ansible_password} ansible_connection=winrm ansible_port=5985 ansible_winrm_server_cert_validation=ignore ansible_winrm_transport=ntlm'"
    when = destroy
  }
}

module "app" {
  source              = "../../../modules-vmware/module-compute"
  vmtemp              = var.vmtemplate
  instances           = app_var.instances_count
  vmname              = app_var.vm_name
  vmfolder            = var.vm_folder
  compute_cluster     = var.compute_cluster
  is_windows_image    = var.is_windows_image
  cpu_number          = app_var.cpu_number
  ram_size            = app_var.ram_size
  network = {
    (var.vlan) = (var.app_ipv4_address) # To use DHCP create Empty list ["",""]
  }
  ipv4submask           = var.ipv4submask
  vmdns                 = var.vmdns
  dc                    = var.dc
  datastore_cluster     = var.datastore_cluster

  # OS disk size comes from the VMware template
  # If you need to increase OS disk size uncomment the line below and add the variable to the variables.tf and terraform.tfvars
  # disk_size_gb          = var.disk_size_gb

  # To add additional disks uncomment the lines below and add the variable to the variables.tf and terraform.tfvars
  # data_disk = {
  #  disk1 = {
  #    size_gb                   = var.data_disk_size_gb,
  #    thin_provisioned          = true,
  #  },
  #}
}

# Create the local ansible inventory file
resource "local_file" "AnsibleInventory" {
  content = templatefile("inventory.tmpl",
    {
      windows-address = module.win_template.Windows-ip
      app-linux-address = module.app.Linux-ip
    }
  )
  filename = "inventory"
}

resource "null_resource" "run-ansible-destroy-app" {
  for_each = toset(module.app.Linux-VM)
  triggers = {
    vmname = each.key
    ansible_user = var.ansible_user
    ansible_password = var.ansible_password
  }
  provisioner "local-exec" {
    command = "ansible-playbook ../../ansible/destroy_playbook.yaml -i 10.10.102.20, --extra-vars 'vmname=${self.triggers.vmname} ansible_user=${self.triggers.ansible_user} ansible_password=${self.triggers.ansible_password} ansible_connection=winrm ansible_port=5985 ansible_winrm_server_cert_validation=ignore ansible_winrm_transport=ntlm'"
    when = destroy
  }
}

module "db" {
  source              = "../../../modules-vmware/module-compute"
  vmtemp              = var.vmtemplate
  instances           = db_var.instances_count
  vmname              = db_var.vm_name
  vmfolder            = db.vm_folder
  compute_cluster     = db.compute_cluster
  is_windows_image    = db.is_windows_image
  cpu_number          = db_var.cpu_number
  ram_size            = db_var.ram_size
  network = {
    (var.db_vlan) = (var.db_ipv4_address) # To use DHCP create Empty list ["",""]
  }
  ipv4submask           = var.ipv4submask
  vmdns                 = var.vmdns
  dc                    = var.dc
  datastore_cluster     = var.datastore_cluster

  # OS disk size comes from the VMware template
  # If you need to increase OS disk size uncomment the line below and add the variable to the variables.tf and terraform.tfvars
  # disk_size_gb          = var.disk_size_gb

  # To add additional disks uncomment the lines below and add the variable to the variables.tf and terraform.tfvars
  # data_disk = {
  #  disk1 = {
  #    size_gb                   = var.data_disk_size_gb,
  #    thin_provisioned          = true,
  #  },
  #}
}

# Create the local ansible inventory file
resource "local_file" "AnsibleInventory" {
  content = templatefile("inventory.tmpl",
    {
      windows-address = module.win_template.Windows-ip
      db-linux-address = module.db.Linux-ip
    }
  )
  filename = "inventory"
}

resource "null_resource" "run-ansible-destroy-db" {
  for_each = toset(module.db.Linux-VM)
  triggers = {
    vmname = each.key
    ansible_user = var.ansible_user
    ansible_password = var.ansible_password
  }
  provisioner "local-exec" {
    command = "ansible-playbook ../../ansible/destroy_playbook.yaml -i 10.10.102.20, --extra-vars 'vmname=${self.triggers.vmname} ansible_user=${self.triggers.ansible_user} ansible_password=${self.triggers.ansible_password} ansible_connection=winrm ansible_port=5985 ansible_winrm_server_cert_validation=ignore ansible_winrm_transport=ntlm'"
    when = destroy
  }
}

resource "null_resource" "run-ansible" {
  triggers = {
      always_run = timestamp()
  }
  provisioner "local-exec" {
    command = "ansible-playbook ../../ansible/${var.stack}_playbook.yaml -i inventory -e 'ENVKEY=${var.envkey} ansible_user=${var.ansible_user} ansible_password=${var.ansible_password} ansible_become_password=${var.ansible_password} admin_groups=${var.admin_groups} allow_groups=${var.allow_groups}'"
  }
  depends_on = [module.web, module.app, module.db]
}