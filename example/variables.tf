variable "vsphere-user" {
  description = "Login credentials (username) for the vSphere server."
  default     = ""
}

variable "vsphere-password" {
  description = "Login credentials (password) for the vSphere server."
  default     = ""
}
variable "vsphere-server" {
  description = "hostname/ip for the vSphere server."
  default     = ""
}
variable "stack" {
  description = "The technology stack to be installed"
  default     = ""
}
variable "ipv4submask" {
  description = "ipv4 Subnet mask."
  type        = list(any)
  default     = ["23"]
}
variable "ipv4_address" {
  description = "IPs for each VM"
  type        = list(string)
}
variable "vmgateway" {
type = map
  description = "Map of VM gateway to set during provisioning."
  default     = {
      "Internal" = ""
      "External" = ""
      "DB" = ""
    }
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
  default     = ""
}
variable "windows" {
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
variable "guest-ips" {
  description = "name of the VLAN the VM will reside."
  default     = ""
}