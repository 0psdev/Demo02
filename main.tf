provider "vsphere" {
  user           = var.VSPHERE_USER
  password       = var.VSPHERE_PASS
  vsphere_server = var.VSPHERE_SERVER

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "datacenter" {
  name = var.VSPHERE_DC
}

data "vsphere_datastore" "datastore" {
  name          = var.VSPHERE_DSG
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.VSPHERE_CLUSTER
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = var.VSPHERE_NETWORK
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.VSPHERE_TEMPLATE
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "vsphere_virtual_machine" "vm" {
  name             = var.VSPHERE_VMNAME
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus         = var.VSPHERE_VCPU
  memory           = var.VSPHERE_VRAM
  guest_id         = data.vsphere_virtual_machine.template.guest_id
  scsi_type        = data.vsphere_virtual_machine.template.scsi_type
  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }
  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      windows_options {
        computer_name = var.VSPHERE_COMNAME
        workgroup    = var.VSPHERE_WK
      }
      network_interface {
        ipv4_address = var.VSPHERE_IP
        ipv4_netmask = var.VSPHERE_NETMASK
      }
      ipv4_gateway = var.VSPHERE_GW
    }
  }
}
