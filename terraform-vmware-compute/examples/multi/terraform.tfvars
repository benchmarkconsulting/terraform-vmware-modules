###################
# Provider Values #
###################

vsphere_user            = ""
vsphere_password        = ""
vsphere_server          = "68278-tdc3-vcsa01.vsphere.local"

######################
# Web Compute Values #
#####################

web_stack                   = ""
envkey                      = ""
web_vmtemplate              = ""
web_instances_count         = 2
web_vm_name                 = "rvw-"
web_vm_folder               = "Univeris VMs/prod/shared-services-internal"
web_compute_cluster         = "Flexpod"
web_is_windows_image        = true
web_cpu_number              = "4"
#Ram size in MB
web_ram_size                = "8192"
web_vlan                    = "pg-VMDATA_sharedServices-Internal"
# The number of IP addresses must equal the instances
web_ipv4_address            = ["10.10.102.103","10.10.102.104"]
#for AD vmdns must be a DNS server that routes over the internet inorder to download the correct packages to deploy AD.
web_vmdns                   = ["8.8.8.8", "8.8.4.4"]
#domain specific vars
web_domain_name             = ""
web_domain_user             = ""
web_domain_password         = ""

######################
# App Compute Values #
######################

app_stack                   = "activedirectory"
environment                 = ""
app_vmtemplate              = "Win2019-Template"
app_instances_count         = 2
app_vm_name                 = "rvw-jonlsb"
app_vm_folder               = "Univeris VMs/prod/shared-services-internal"
app_compute_cluster         = "Flexpod"
app_is_windows_image        = true
app_cpu_number              = "4"
#Ram size in MB
app_ram_size                = "8192"
app_vlan                    = "pg-VMDATA_sharedServices-Internal"
# The number of IP addresses must equal the instances
app_ipv4_address            = ["10.10.102.103","10.10.102.104"]
#for AD vmdns must be a DNS server that routes over the internet inorder to download the correct packages to deploy AD.
app_vmdns                   = ["8.8.8.8", "8.8.4.4"]
#domain specific vars
app_domain_name             = ""
app_domain_user             = ""
app_domain_password         = ""