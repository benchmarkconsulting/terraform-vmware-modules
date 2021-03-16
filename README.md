# Terraform modules for VMWare

A registry of modules to create a VMWare environment 
The resources/services/activations/deletions that these modules include are:
- Module for 
    - compute

## Ansible for machine configuration
- Leverages ansible and dynamic inventory to configure machine after provisions

## Usage

```hcl
module "<module>" {
    source = "git::https://github.com/benchmarkconsulting/vmware-terraform-modules//<module>"
```
## Deploys Virtual Machines to your vSphere environment

This Terraform module deploys virtual machines either (Linux/Windows) with following features:
- Ability to specify Linux or Windows VM customization.

## Getting started

Following example contains the bare minimum options to be configured for (Linux/Windows) VM deployment. You can choose between windows and linux customization by simply using the ´is_windows_image´ boolean switch.

You can also download the entire module and use your own predefined variables to map your entire vSphere environment and use it within this module.

__Copy the files from examples. fill the required data in terraform.tfvars and run terraform plan.__

```
vsphere-user      = ""
vsphere-password  = ""
vsphere-server    = ""
stack             = ""
vmtemplate        = ""
instances_count   = 
vm_name           = ""
vm_folder         = ""
compute_cluster   = ""
cpu_number        = ""
ram_size          = ""
windows           = false/true
vlan              = ""
ipv4_address      = [""]
```
