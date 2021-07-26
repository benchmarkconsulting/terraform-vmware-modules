# Terraform vSphere Virtual Machine Module Examples

For Virtual Machine Provisioning with (Linux/Windows) customization. Based on Terraform v0.14, this module include most of the advance features that are available in the resource `vsphere_virtual_machine`.

## Object Information 

### main.tf

**main.tf**

```hcl
### Provider Information
provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

### Module Defined Variables
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
      linuxipv4-address = module.example-single-linux-server.Linux-ip  <-- Host Group to set in inventory template
    }
  )
  filename = "inventory"
}

resource "null_resource" "run-ansible" {
   triggers = {
     always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "ansible-playbook ../../ansible/${var.stack}_playbook.yaml -i inventory --extra-vars 'ENVKEY=${var.environment}'"  <-- Extra vars to override in ansible
  }
  depends_on = [module.example-single-linux-server]  <-- Wait for Infrastructure to Complete before running ansible
}

```

### inventory

**inventory.tmpl**

```
[all:vars]
ansible_connection=ssh
ansible_user=admin
ansible_ssh_pass=
ansible_become=yes
ansible_become_password=
host_key_checking=False

[example-single-linux-server]  <-- Host Group for Ansible
%{ for index, ip in linuxipv4-address ~}  <-- template variable for machine IP
${ip}
%{ endfor ~}
```

### Ansible Playbook

```yml
---
- hosts: example-single-linux-server  <-- Host group from Inventory file
  vars:
    key: value                        <-- Group Variables
  roles:
     - {roles1}                       <-- Defined Ansible Roles
     - {roles2}
```


### GCS Backend

```hcl

Example Configuration
terraform {
  backend "gcs" {
    bucket  = "tf-state-prod"
    prefix  = "terraform/state"
  }
}

```
#### Authentication

User: auth application-default login.
Generate a service account key and set the GOOGLE_APPPLICATION_CREDENTIALS environment variable to the path of the service account key. Terraform will use that key for authentication.
https://www.terraform.io/docs/language/settings/backends/gcs.html

