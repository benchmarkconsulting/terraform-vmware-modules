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
variable "disk_size_gb" {
  description = "size of the system disk. If not set will use the template disk size."
}

variable "stack" {
  description = "The technology stack to be installed"
  default     = ""
}

variable "vmdns" {
  description = "DNS servers for the VM"
  type        = list(any)
  default     = ["8.8.8.8", "8.8.4.4"]
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

variable "product_key" {
  description = "Product key to be used during windows customization."
  default     = null
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

variable "guest-ips" {
  description = "name of the VLAN the VM will reside."
  default     = ""
}

##domain specific
variable "domain_name" {
  description = "FQDN od the domain to create"
  default     = ""
}

variable "domain_user" {
  description = "user with rights to the domain. by defualt this will be the admin from the windows image build"
  default     = ""
}

variable "site_name" {
  description = "Name of the first site for sites and services."
  default     = ""
}

variable "site_description" {
  description = "description of the site."
  default     = ""
}

variable "domain_password" {
  description = "password for the account that has domain admin privleges."
  default     = ""
}

variable "recovery_password" {
  description = "recovery password for the domain"
  default     = ""
}
 
variable "dc" {
  description = "name of the dc the VM will reside."
  default     = "68278-Univeris"
}

variable "datastore_cluster" {
  description = "name of the datastore_cluster the VM will reside."
  default     = "68278-SAN01"
}