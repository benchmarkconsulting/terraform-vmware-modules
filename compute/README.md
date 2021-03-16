# Terraform modules for VMWare

A registry of modules to create a VMWare environment 
The resources/services/activations/deletions that these modules include are:
- Module for 
    - compute

## Compatibility

This module is meant for use with Terraform 0.12. If you haven't
[upgraded][terraform-0.12-upgrade].

## Usage

```hcl
module "<module>" {
    source = "git::https://github.com/benchmarkconsulting/vmware-terraform-modules//<module>"
```
