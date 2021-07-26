###################
# Provider Values #
###################

vsphere_user            = ""
vsphere_password        = ""
vsphere_server          = "68278-tdc3-vcsa01.vsphere.local"

##################
# Compute Values #
##################

stack                   = ""
environment             = ""
vmtemplate              = ""
instances_count         = 2
vm_name                 = ""
vm_folder               = "Univeris VMs/prod/shared-services-internal"
compute_cluster         = "Flexpod"
is_windows_image        = true
cpu_number              = "4"
#Ram size in MB
ram_size                = "8192"
vlan                    = "pg-VMDATA_sharedServices-Internal"
# The number of IP addresses must equal the instances
ipv4_address            = ["10.10.102.103","10.10.102.104"]
#for AD vmdns must be a DNS server that routes over the internet inorder to download the correct packages to deploy AD.
vmdns                   = ["8.8.8.8", "8.8.4.4"]
#domain specific vars
domain_name             = ""
domain_user             = ""
domain_password         = ""