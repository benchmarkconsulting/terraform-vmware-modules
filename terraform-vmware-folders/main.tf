data "vsphere_datacenter" "dc" {
  name = var.vsphere_vcenter_dc
}

data "vsphere_compute_cluster" "compute_cl" {
  name          = var.vsphere_vcenter_cl
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_folder" "tier1" {
  path          = "/${var.vsphere_folder_root}/${var.vsphere_folder_tier1}"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_folder" "tier2" {
  for_each      = toset(var.vsphere_folder_tier2)
  path          = "/${vsphere_folder.tier1.path}/${each.value}"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}