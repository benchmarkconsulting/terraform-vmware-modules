# Getting off the ground quickly

Terraform and Ansible are being used at Univeris to help define, provision and configure Technology Stacks.  A technology stack is a server or group of servers that serve a purpose.

All servers are built and configured with code.  This enables a great deal of flexibility when creating new technology stacks.  While the code is detailed, there are a few key files and values that drive most of the construction.  Understanding how these fit together will give you a good understanding of what it takes to tweak a current stack or even create a new one.

As most technology stacks will be comprised of more than one server, we will use a multi-server scenario as the basis for our example.  There are 3 phases that go into constructing a stack:

[PLAN - Define your stack](#markdown-header-plan-define-your-stack)  
[PROVISION - Build your stack](#markdown-header-Build-the-servers-for-your-stack-with-Terraform)  
[CONFIGURE - Configure your stack](#markdown-header-Configure-the-servers-for-your-stack-with-Ansible)

## Background and foundations:

### When building a technology stack, the servers are:

* created to your specification (Terraform)
* configured to your specification (Ansible)
    * added to Active Directory
        * RBAC groups are applied
    * added to New Relic

### When destroying your technology stack, the servers are:

* removed from their home cloud (Rogers/Google)
* removed from Active Directory

### TO BUILD YOUR OWN STACK:

1) Create a new branch on the [DevOps/Infracode Repository](http://stash.univeris.com/projects/DEVOPS/repos/infracode/browse) in Bitbucket.

2) Clone the repository

```
git clone -b <branch name> ssh://git@stash.univeris.com:7999/devops/infracode.git
```

3) Navigate to the terraform folder

```
cd infracode/terraform
```

4) Create a new folder with the name of the stack you want to build

5) Copy the contents of the **template** folder into your new stack folder

--------------------------

There are 4 default files in each stack folder.

Taking the time to determine the technology makeup of your stack will enable you to collect and provide the required information for each of these files.  These files feed off each other to create your technology stack.  After adding or updating a value in one file, review the other files to make appropriate updates where required.


| File Name | Description | Association with other files |
|------|-------------|--------|
| `main.tf` | specifies information about the makeup of your servers | modifications require that the associated variable is added or removed from `variables.tf` |
| `variables.tf` | declares the variables used in `main.tf` | modifications require that the associated reference and value is added or removed from `terraform.tfvars` |
| `terraform.tfvars` | sets the values for your variables in `variables.tf` for use in `main.tf` | modifications require that the associated variable or reference is added or removed from `variables.tf` and `main.tf` |
| `inventory.tmpl` | uses outputs from Terraform to build your Ansible inventory  | modifications to the **local ansible inventory file** section of `main.tf` need to be made in `inventory.tmpl` |

![terraform_links](../../../images/terraform_files_linkage.svg)


![ansible_links](../../../images/ansible_files_linkage.svg)


![module_links](../../../images/module_linkage.svg)

In addition to these 4 files, you must also create a `stack_playbook.yaml` file in the **infracode/terraform** folder where **stack** matches name of the stack you are building (eg. If the stack was for **g5**, your playbook would be called `g5_playbook.yaml`)

| File Name | Description | Association with other files |
|------|-------------|--------|
| `stack_playbook.yaml` | Ansible playbook for configuring your stack  | modifications to the hosts in `inventory.tmpl` file need to be reflected in this playbook |

![stack_playbook_links](../../../images/stack_playbook_link.svg)

## Plan - Define your Stack

This is a high level understanding of what components are required to deliver the functioning application/technology.  Mapping out your stack will help you to determine the values of the files used to create your stack.  A strong **Plan** provides the foundation to give you everything you need in the **Provision** and **Configure** phases.

Servers of a similar type within your stack become named modules in the `main.tf` file.  In this example we have a **web** server an **app** server and a **db** server.


## Mapping a Plan to a Provision

Every server in your technology stack that performs a different function will require a unique module name.  In the example above, we see **web** and **app** and **db**.  The underlying source for the module is very robust.  It allows you to pass values (through variables), call the same underlying module and still create unique technology stacks.

Define the role of the server in the stack (web, app, db).  Refer to vendor documentation or current documentation to lay out the specific requirements for your servers.  Group common variables together where possible.  Any specific requirements for additional modules require additional variables.

In the example below, all of the servers are Non-Prod servers for the 'jac' stack, built on RHEL7.  The VMs all have 40 GB hard drives and once built will be stored in the **dev/dev-internal** folder for Univeris VMs.  

The rest of the variables are unique based on the purpose of the server being built.  These unique modules require unique variables.  When you are finished recording the details of your plan, add the additional variables to the `variables.tf` file and `terraform.tfvars` file, recording the appropriate value in `terraform.tfvars` file.


**COMMON**

| Variable Name | Description | Type | Example Value | Required | Reference Link |
|---------------|-------------|------|---------------|:--------:|----------------|
| var.vmtemplate | OS template name from VSphere | `string` | `RHEL7-Template-HCL` | yes | |
| var.disk_size_gb | Default disk size (in MB) | `string` | `40960` | yes | |
| var.envkey | the environment that the stack resides in. Production/Non-Prod | `string` | `Non-Prod` | yes | |
| var.stack | The technology stack to be installed | `string` | `jac` | yes | |
| var.vm_folder | The Folder in VCenter that the server is stored in | `string` | `Univeris VMs/dev/dev-internal` | yes | |
| var.vmdns | DNS servers for the VM.| `list(any)` | `["10.10.102.20", "10.10.102.21"]` | yes | | 
| var.ipv4submask | ipv4 Subnet mask. | `list(any)` | `["23"]` | yes | |
| var.compute_cluster | Cluster resource pool that VM will be deployed to. | `string` | `"Flexpod"` | yes | |
| var.dc | Name of the dc the VM will reside. | `string` | `"68278-Univeris"` | yes | |
| var.datastore_cluster | Name of the datastore_cluster the VM will reside. | `string` | `"68278-SAN01"` | yes | |


**WEB Specific**

| Variable Name | Description | Type | Example Value | Required | Reference Link |
|---------------|-------------|------|---------------|:--------:|----------------|
| var.web_instances_count | Number of servers to build | `string` | `1` | yes | |
| var.web_vm_name | The Name of the server(s) | `string` | `jac-t-r-web` | yes | [Naming Convention](https://portal.univeris.com/pages/viewpage.action?spaceKey=infra&title=Naming+Convention) |
| var.web_cpu_number | CPU Count | `string` | `4` | yes | |
| var.web_ram_size | Amount of RAM (in MB) | `string` | `4096`| yes |  |
| var.vlan | Name of the VLAN where the servers will reside | `string` | `pg-VMDATA_DEV-Internal` | yes |  |
| var.web_ipv4_address | IP Address(es) for the server(s) | `string` | `10.10.118.31` | yes | [IP Address Spreadsheet](https://docs.google.com/spreadsheets/d/1h6KOHriAT5_RBpo-uSRHGaTmSasxX0M4y5TLsSUY-h0) |


**APP Specific**

| Variable Name | Description | Type | Example Value | Required | Reference Link |
|------|-------------|------|---------|:--------:|---------|
| var.app_instances_count | Number of servers to build | `string` | `1` | yes |  |
| var.app_vm_name | The Name of the server(s) | `string` | `jac-t-r-app` | yes | [Naming Convention](https://portal.univeris.com/pages/viewpage.action?spaceKey=infra&title=Naming+Convention) | 
| var.app_cpu_number | CPU Count | `string` | `4` | yes |  |
| var.app_ram_size | Amount of RAM (in MB) | `string` | `8196`| yes |  |
| var.vlan | Name of the VLAN where the servers will reside | `string` | `pg-VMDATA_DEV-Internal` | yes | |
| var.app_ipv4_address | IP Address(es) for the server(s) | `string` | `10.10.118.32` | yes | [IP Address Spreadsheet](https://docs.google.com/spreadsheets/d/1h6KOHriAT5_RBpo-uSRHGaTmSasxX0M4y5TLsSUY-h0) |


**DB Specific**

| Variable Name | Description | Type | Example Value | Required | Reference Link |
|------|-------------|------|---------|:--------:|---------|
| var.db_vmtemplate | OS template name from VSphere | `string` | `RHEL7-Template-HCL` | yes | |
| var.db_instances_count | Number of servers to build | `string` | `1` | yes | |
| var.db_vm_name | The Name of the server(s) | `string` | `jac-t-r-db` | yes | [Naming Convention](https://portal.univeris.com/pages/viewpage.action?spaceKey=infra&title=Naming+Convention) |
| var.db_cpu_number | CPU Count | `string` | `4` |  |
| var.db_ram_size | Amount of RAM (in MB) | `string` | `8192`| yes | |
| var.db_vlan | Name of the VLAN where the servers will reside | `string` | `pg-VMDATA_DEV-DB` | yes | |
| var.db_ipv4_address | IP Address(es) for the server(s) | `string` | `10.10.120.31` | yes | [IP Address Spreadsheet](https://docs.google.com/spreadsheets/d/1h6KOHriAT5_RBpo-uSRHGaTmSasxX0M4y5TLsSUY-h0) |


**IMPORTANT TO REMEMBER**

* Each module requires a unique name
* Any common variables can be reused between modules (eg. if the OS stays the same there is no need to create a unique variable for each module)
* The Ansible inventory template must be updated with IP address reference from your specific module information in the **local ansible inventory file** 

**Once your Plan is defined, ensure:**

1) Each variable added to your `main.tf` is represented in your `variables.tf` file and `terraform.tfvars` file
2) The actual values for these fields are recorded in your `terraform.tfvars` file
3) Ensure that any changes to module references are reflected in your `main.tf`

## Provision - Build the servers for your stack with Terraform

ORIGINAL `main.tf` FILE

```hcl
provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

### When adding additional modules start your copy here. ###
module "win_template" {
  source              = "../../../modules-vmware/module-compute"
  vmtemp              = var.vmtemplate
  instances           = var.instances_count
  vmname              = var.vm_name
  vmfolder            = var.vm_folder
  compute_cluster     = var.compute_cluster
  is_windows_image    = var.is_windows_image
  cpu_number          = var.cpu_number
  ram_size            = var.ram_size
  network = {
    (var.vlan) = (var.ipv4_address) # To use DHCP create Empty list ["",""]
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

resource "null_resource" "run-ansible-destroy-web" {
  for_each = toset(module.win_template.Windows-VM)
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

### When adding additional modules stop your copy here. ###
# Create the local ansible inventory file
resource "local_file" "AnsibleInventory" {
  content = templatefile("inventory.tmpl",
    {
      windows-address = module.win_template.Windows-ip
      linux-address = module.win_template.Linux-ip
    }
  )
  filename = "inventory"
}

resource "null_resource" "run-ansible" {
  triggers = {
      always_run = timestamp()
  }
  provisioner "local-exec" {
    command = "ansible-playbook ../../ansible/${var.stack}_playbook.yaml -i inventory -e 'ENVKEY=${var.envkey} ansible_user=${var.ansible_user} ansible_password=${var.ansible_password} ansible_become_password=${var.ansible_password} admin_groups=${var.admin_groups} allow_groups=${var.allow_groups}'"
  }
  depends_on = [module.win_template]
}
```

UPDATED `main.tf` FOR SAMPLE

```hcl
provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

module "web" {
  source              = "../../../modules-vmware/module-compute"
  vmtemp              = var.vmtemplate
  instances           = var.web_instances_count
  vmname              = var.web_vm_name
  vmfolder            = var.vm_folder
  compute_cluster     = var.compute_cluster
  is_windows_image    = var.is_windows_image
  cpu_number          = var.web_cpu_number
  ram_size            = var.web_ram_size
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
  instances           = var.app_instances_count
  vmname              = var.app_vm_name
  vmfolder            = var.vm_folder
  compute_cluster     = var.compute_cluster
  is_windows_image    = var.is_windows_image
  cpu_number          = var.app_cpu_number
  ram_size            = var.app_ram_size
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

// # Create the local ansible inventory file
// resource "local_file" "AnsibleInventory-app" {
//   content = templatefile("inventory.tmpl",
//     {
//       windows-address = module.win_template.Windows-ip
//       app-linux-address = module.app.Linux-ip
//     }
//   )
//   filename = "inventory"
// }

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
  instances           = var.db_instances_count
  vmname              = var.db_vm_name
  vmfolder            = var.vm_folder
  compute_cluster     = var.compute_cluster
  is_windows_image    = var.is_windows_image
  cpu_number          = var.db_cpu_number
  ram_size            = var.db_ram_size
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

// # Create the local ansible inventory file
// resource "local_file" "AnsibleInventory-db" {
//   content = templatefile("inventory.tmpl",
//     {
//       windows-address = module.win_template.Windows-ip
//       db-linux-address = module.db.Linux-ip
//     }
//   )
//   filename = "inventory"
// }

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

# Create the local ansible inventory file
resource "local_file" "AnsibleInventory" {
  content = templatefile("inventory.tmpl",
    {
      web-linux-address = module.web.Linux-ip
      db-linux-address = module.db.Linux-ip
      app-linux-address = module.app.Linux-ip
    }
  )
  filename = "inventory"
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

```

### `variables.tf`

Any new variables from your **Plan** exercise map must be added to your `variables.tf` file

ORIGINAL `variables.tf` FILE

```hcl
variable "vsphere_user" {
  description = "Login credentials (username) for the vSphere server."
  default     = ""
}

variable "vsphere_password" {
  description = "Login credentials (password) for the vSphere server."
  default     = ""
}

variable "vsphere_server" {
  description = "hostname/ip for the vSphere server."
  default     = ""
}

variable "vmtemplate" {
  description = "Name of the template available in the vSphere."
  default     = ""
}

variable "instances_count" {
  description = "number of instances you want deploy from the template."
  default     = 1
}

variable "vm_name" {
  description = "The name of the virtual machine used to deploy the vms."
  default     = ""
}

variable "vm_folder" {
  description = "The path to the folder to put this virtual machine in, relative to the datacenter that the resource pool is in."
  default     = null
}

variable "compute_cluster" {
  description = "Cluster resource pool that VM will be deployed to."
  default     = "Flexpod"
}

variable "is_windows_image" {
  description = "Boolean flag to notify when the custom image is windows based."
  type        = bool
  default     = false
}

variable "cpu_number" {
  description = "the number of CPUs."
  default     = ""
}

variable "ram_size" {
  description = "The amount of RAM."
  default     = ""
}

variable "vlan" {
  description = "name of the VLAN the VM will reside."
  default     = ""
}

variable "ipv4_address" {
  description = "IPs for each VM"
  type        = list(string)
}

variable "ipv4submask" {
  description = "ipv4 Subnet mask."
  type        = list(any)
  default     = ["23"]
}

variable "vmdns" {
  description = "DNS servers for the VM"
  type        = list(any)
  default     = ["10.10.102.20", "10.10.102.21"]
}

variable "dc" {
  description = "name of the dc the VM will reside."
  default     = "68278-Univeris"
}

variable "datastore_cluster" {
  description = "name of the datastore_cluster the VM will reside."
  default     = "68278-SAN01"
}

variable "disk_size_gb" {
  description = "size of the system disk. If not set will use the template disk size."
  default     = ""
}

variable "data_disk_size_gb" {
  description = "size of the disk"
  default     = ""
}

variable "stack" {
  description = "The technology stack to be installed"
  default     = ""
}
variable "envkey" {
  description = "the environment that the stack resides in. Production/Non-Prod"
  default = ""
}

variable "ansible_user" {
  description = "user with rights to run ansible. On Windows, this will also join the server to the domain"
  default     = ""
}

variable "ansible_password" {
  description = "password for the ansible_user account."
  default     = ""
}

variable "admin_groups" {
  description = "Groups to add as sudoers(Linux), Administrators(Windows) Do not use Spaces."
  default     = ""
}

variable "allow_groups" {
  description = "Groups to add as allowgroups(Linux), Remote desktop users(Windows). Do not use Spaces"
  default     = ""
}
```

UPDATED `variables.tf` FOR SAMPLE

```hcl
variable "vsphere_user" {
  description = "Login credentials (username) for the vSphere server."
  default     = ""
}

variable "vsphere_password" {
  description = "Login credentials (password) for the vSphere server."
  default     = ""
}

variable "vsphere_server" {
  description = "hostname/ip for the vSphere server."
  default     = ""
}

variable "vmtemplate" {
  description = "Name of the template available in the vSphere."
  default     = ""
}

variable "web_instances_count" {
  description = "number of instances you want deploy from the template."
  default     = 1
}

variable "app_instances_count" {
  description = "number of instances you want deploy from the template."
  default     = 1
}

variable "db_instances_count" {
  description = "number of instances you want deploy from the template."
  default     = 1
}

variable "web_vm_name" {
  description = "The name of the virtual machine used to deploy the vms."
  default     = ""
}

variable "app_vm_name" {
  description = "The name of the virtual machine used to deploy the vms."
  default     = ""
}

variable "db_vm_name" {
  description = "The name of the virtual machine used to deploy the vms."
  default     = ""
}

variable "vm_folder" {
  description = "The path to the folder to put this virtual machine in, relative to the datacenter that the resource pool is in."
  default     = null
}

variable "compute_cluster" {
  description = "Cluster resource pool that VM will be deployed to."
  default     = "Flexpod"
}

variable "is_windows_image" {
  description = "Boolean flag to notify when the custom image is windows based."
  type        = bool
  default     = false
}

variable "web_cpu_number" {
  description = "the number of CPUs."
  default     = ""
}

variable "app_cpu_number" {
  description = "the number of CPUs."
  default     = ""
}

variable "db_cpu_number" {
  description = "the number of CPUs."
  default     = ""
}

variable "web_ram_size" {
  description = "The amount of RAM."
  default     = ""
}

variable "app_ram_size" {
  description = "The amount of RAM."
  default     = ""
}

variable "db_ram_size" {
  description = "The amount of RAM."
  default     = ""
}

variable "vlan" {
  description = "name of the VLAN the VM will reside."
  default     = ""
}

variable "db_vlan" {
  description = "name of the VLAN the VM will reside."
  default     = ""
}

variable "web_ipv4_address" {
  description = "IPs for each VM"
  type        = list(string)
}

variable "app_ipv4_address" {
  description = "IPs for each VM"
  type        = list(string)
}

variable "db_ipv4_address" {
  description = "IPs for each VM"
  type        = list(string)
}

variable "ipv4submask" {
  description = "ipv4 Subnet mask."
  type        = list(any)
  default     = ["23"]
}

variable "vmdns" {
  description = "DNS servers for the VM"
  type        = list(any)
  default     = ["10.10.102.20", "10.10.102.21"]
}

variable "dc" {
  description = "name of the dc the VM will reside."
  default     = "68278-Univeris"
}

variable "datastore_cluster" {
  description = "name of the datastore_cluster the VM will reside."
  default     = "68278-SAN01"
}

variable "disk_size_gb" {
  description = "size of the system disk. If not set will use the template disk size."
  default     = ""
}

variable "data_disk_size_gb" {
  description = "size of the disk"
  default     = ""
}

variable "stack" {
  description = "The technology stack to be installed"
  default     = ""
}
variable "envkey" {
  description = "the environment that the stack resides in. Production/Non-Prod"
  default = ""
}

variable "ansible_user" {
  description = "user with rights to run ansible. On Windows, this will also join the server to the domain"
  default     = ""
}

variable "ansible_password" {
  description = "password for the ansible_user account."
  default     = ""
}

variable "admin_groups" {
  description = "Groups to add as sudoers(Linux), Administrators(Windows) Do not use Spaces."
  default     = ""
}

variable "allow_groups" {
  description = "Groups to add as allowgroups(Linux), Remote desktop users(Windows). Do not use Spaces"
  default     = ""
}
```

### `terraform.tfvars`

The values from your **Plan** exercise map directly to the terraform.tfvars file

ORIGINAL `terraform.tfvars` FILE

```hcl
vsphere_user            = ""
vsphere_password        = ""
vsphere_server          = "68278-tdc3-vcsa01.vsphere.local"
stack                   = ""
vmtemplate              = ""
instances_count         = 1
vm_name                 = ""
vm_folder               = ""
compute_cluster         = "Flexpod"
is_windows_image        = true
cpu_number              = "2"
#Ram size in MB
ram_size                = "4096"
disk_size_gb            = [40]
data_disk_size_gb       = 100
vlan                    = ""
# The number of IP addresses must equal the instances
ipv4_address            = [""]
vmdns                   = ["10.10.102.20", "10.10.102.21"]
envkey                  = ""
ansible_user            = ""
ansible_password        = ""
#Groups to add as sudoers(Linux) or Administrators(Windows). Sudoers will also be added to the allow gourps automatially. Do not use Spaces
#At least one group must exist for Linux machines or SSSD will fail and machine will need to be destoryed.
admin_groups            = "usr_devops_inf_sr"
#Groups to add as allowgroups(Linux), Remote desktop users(Windows). Do not use Spaces
allow_groups            = ""
```

UPDATED `variables.tf` FOR SAMPLE

```hcl
vsphere_user            = "<redacted>"
vsphere_password        = "<redacted>"
vsphere_server          = "68278-tdc3-vcsa01.vsphere.local"
stack                   = "jac"
vmtemplate              = "RHEL7-Template-HCL"
web_instances_count     = 1
app_instances_count     = 2
db_instances_count      = 1
web_vm_name             = "jac-t-r-web"
app_vm_name             = "jac-t-r-app"
db_vm_name              = "jac-t-r-db"
vm_folder               = "Univeris VMs/dev/dev-internal"
compute_cluster         = "Flexpod"
is_windows_image        = false
web_cpu_number          = "2"
app_cpu_number          = "2"
db_cpu_number           = "4"
#Ram size in MB
web_ram_size            = "4096"
app_ram_size            = "4096"
db_ram_size             = "8192"
disk_size_gb            = [40]
#data_disk_size_gb      = 100
vlan                    = "pg-VMDATA_DEV-Internal"
db_vlan                 = "pg-VMDATA_DEV-DB"
# The number of IP addresses must equal the instances
web_ipv4_address        = ["10.10.118.31"]
app_ipv4_address        = ["10.10.118.32", "10.10.118.33"]
db_ipv4_address         = ["10.10.120.31"]
vmdns                   = ["10.10.102.20", "10.10.102.21"]
envkey                  = "Non-Prod"
ansible_user            = "<redacted>"
ansible_password        = "<redacted>"
#Groups to add as sudoers(Linux) or Administrators(Windows). Sudoers will also be added to the allow gourps automatially. Do not use Spaces
#At least one group must exist for Linux machines or SSSD will fail and machine will need to be destoryed.
admin_groups            = "usr_devops_inf_sr"
#Groups to add as allowgroups(Linux), Remote desktop users(Windows). Do not use Spaces
allow_groups            = ""
```

## Configure - Configure the servers for your stack with Ansible

Immediately after Terraform has provisioned your servers, Ansible will configure the servers for you based on the information provided in the stack specific playbook.

The stack specific playbook:

1) Imports and applies the appropriate base OS configuration 
2) Adds any additonal selected Ansible roles


Create a Playbook under **univeris/ansible** with the name `stack_playbook.yaml` where stack is the name of the stack you are building.  This playbook allows you to configure your new servers for their specific purpose.  In this example, the playbook would be name `jac_playbook.yaml` to match the name of the stack folder that we created for Terraform.

SAMPLE `stack_playbook.yaml`

```yml
---
- import_playbook: base_linux_playbook.yaml

- hosts: WEB
  roles:
    - jboss

- hosts: APP
  roles:
    - openjdk

- hosts: DB
  roles:
    - mongo
```

The server group names in the inventory file must match the -hosts name in your playbook... (example), if you are calling out something specifically. (Not ALL)

The inventory links directly to your playbook file.

ORIGINAL `inventory.tmpl` FILE
```
[windows]
%{ for index, ip in windows-address ~}
${ip}
%{ endfor ~}

[windows:vars]
ansible_connection=winrm
ansible_port=5985
ansible_winrm_transport=ntlm
ansible_winrm_server_cert_validation=ignore

[linux]
%{ for index, ip in linux-address ~}
${ip}
%{ endfor ~}

[linux:vars]
ansible_connection=ssh
ansible_become=yes
host_key_checking=False
```

UPDATED `inventory.tmpl` FOR SAMPLE

```
[all:vars]
ansible_connection=ssh
ansible_become=yes
host_key_checking=False

[WEB]
%{ for index, ip in web-linux-address ~}
${ip}
%{ endfor ~}

[APP]
%{ for index, ip in app-linux-address ~}
${ip}
%{ endfor ~}

[DB]
%{ for index, ip in db-linux-address ~}
${ip}
%{ endfor ~}
```
#### Increasing Primary Disk Size or Adding Additional Disks

Default disk size comes from the VMware template.  Defaults for all operating systems are 40 GB.

The code for increasing primary and adding additional disk sizes are is already contained in `main.tf`, but commented out.

```hcl
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
  ```

To increase primary disk size, uncomment the line below and ensure the size of the new disk is added to `terraform.tfvars`

```
disk_size_gb          = var.disk_size_gb
```

![primary_disk_links](../../../images/primary_disk_linkage.svg)

To add additional disks for Windows, uncomment the lines below and ensure the size of the new disk is added to `terraform.tfvars`. If adding multiple additional disks, you can copy and paste the following code block repeatedly.  Be sure to increment the disk number and ensure that you add any new variables to `variables.tf` and record the size in `terraform.tfvars`

```
   data_disk = {
    disk1 = {
      size_gb                   = var.data_disk_size_gb,
      thin_provisioned          = true,
    },
  }
```

![additional_disk_links](../../../images/additional_disk_linkage.svg)

-------------
Below here might not matter any more

# Terraform vSphere Virtual Machine Module

For Virtual Machine Provisioning with (Linux/Windows) customization. Based on Terraform v0.14, this module include most of the advance features that are available in the resource `vsphere_virtual_machine`.

## Deploys (Single/Multiple) Virtual Machines

This Terraform module deploys virtual machines (Linux/Windows) with following features:

- Ability to specify Linux or Windows VM customization.
## Advance Usage



## Examples

Examples are located in the examples directory

1. Single Module VMs [single](https://github.com/benchmarkconsulting/univeris/tree/main/terraform/modules-vmware/module-compute/examples/single)
2. Multi Module VMs [multi](https://github.com/benchmarkconsulting/univeris/tree/main/terraform/modules-vmware/module-compute/examples/multi)

## Ansible Integration

1. Ansible Runs after the Virtual Machines creation is complete. 
2. Uses An Inventory Template to create a dynamic Inventory.

```
[all:vars]  <-- Ansible Connection variables
ansible_connection=ssh
ansible_user=admin
ansible_ssh_pass=
ansible_become=yes
ansible_become_password=
host_key_checking=False

[RHEL]  <-- ansible role
%{ for index, ip in linuxipv4-address ~}  <-- IP address of each virutal machine created. This is Set in main.tf.v  
${ip}
%{ endfor ~}
```
```
resource "local_file" "AnsibleInventory" {
  content = templatefile("inventory.tmpl",
    {
      linuxipv4-address = module.example-single-linux-server.Linux-ip
    }
  )
  filename = "inventory"
}
```

For complete list of available features please refer to [variable.tf](https://github.com/benchmarkconsulting/univeris/blob/main/terraform/vmware-terraform-modules/vmware-terraform-compute/module/variables.tf)


## Inputs Provider

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vsphere_user | Login credentials (username) for the vSphere server. | `string`| `""` | yes |
| vsphere_password | Login credentials (password) for the vSphere server. | `string` | `""` | yes |
| vsphere_server | hostname/ip for the vSphere server. | `string` | `""` | yes |


## Inputs Module

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| stack | The technology stack to be installed. | `string`| `""` | yes |
| vmdns | DNS servers for the VM.| `list(any)` | `["10.10.102.20", "10.10.102.21"]` | yes |
| ipv4submask | ipv4 Subnet mask. | `list(any)` | `["23"]` | yes |
| ipv4_address | IPs for each VM. | `list(string)` | `[""]` | yes |
| vmtemplate | Name of the template available in the vSphere. | `string` | `""` | yes |
| instances_count | Number of instances you want deploy from the template. | `string` | `"1"` | yes |
| vm_name | The path to the folder to put this virtual machine in, relative to the datacenter that the resource pool is in. | `string` | `""` | yes |
| vm_folder | Map of VM gateway to set during provisioning. | `map(map(string))` | `[]` | yes |
| compute_cluster | Cluster resource pool that VM will be deployed to. | `string` | `"Flexpod"` | yes |
| is_windows_image | Boolean flag to notify when the custom image is windows based. | `bool` | `false` | yes |
| cpu_number | The number of CPUs. | `string` | `""` | yes |
| ram_size | The amount of RAM. | `string` | `""` | yes |
| vlan | Name of the VLAN the VM will reside. | `string` | `""` | yes |
| dc | Name of the dc the VM will reside. | `string` | `"68278-Univeris"` | yes |
| datastore_cluster | Name of the datastore_cluster the VM will reside. | `string` | `"68278-SAN01"` | yes |

## Outputs

| Name | Description |
|------|-------------|
| DC_ID | id of vSphere Datacenter |
| ResPool_ID | Resource Pool id |
| Windows-VM | Windows VM Names |
| Windows-ip | default ip address of the deployed VM |
| Windows-guest-ip | all the registered ip address of the VM |
| Windows-uuid | UUID of the VM in vSphere |
| Linux-VM | Linux VM Names |
| Linux-ip | default ip address of the deployed VM |
| Linux-guest-ip | all the registered ip address of the VM |
| Linux-uuid | UUID of the VM in vSphere |

## Contributing

We appreciate your help!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

[MIT](LICENSE)