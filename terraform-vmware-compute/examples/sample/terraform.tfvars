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
disk_size_gb            = [60]
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