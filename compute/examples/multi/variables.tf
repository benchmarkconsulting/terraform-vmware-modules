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
  default     = ["8.8.8.8", "8.8.4.4"]
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
}


variable "ansible_user" {
  description = "user with rights to run ansible. On Windows, this will also join the server to the domain"
  default     = ""
}

variable "ansible_password" {
  description = "password for the ansible_user account."
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