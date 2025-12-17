# Virtual Machine Lookup
data "netbox_virtual_machines" "lookup" {
  name_regex = var.name
}

data "netbox_cluster" "lookup" {
  id = local.vm.cluster_id
}

data "netbox_interfaces" "lookup" {
  filter {
    name  = "vm_id"
    value = local.vm.vm_id
  }
}

data "netbox_virtual_disk" "lookup" {
  name_regex = "^${var.name}-\\d$"
}

data "netbox_device_role" "lxc" {
  name = "LXC"
}

locals {
  vm = data.netbox_virtual_machines.lookup.vms[0]
  nics = [for i in data.netbox_interfaces.lookup.interfaces :
    {
      id          = tonumber(replace(i.name, "eth", ""))
      name        = i.name
      mac_address = i.mac_address
      domain      = !strcontains(i.mac_address, ":DE:AD:BE:EF:")
    }
  ]
  disks = [for d in data.netbox_virtual_disk.lookup.virtual_disks :
    {
      id          = tonumber(replace(d.name, "${var.name}-", ""))
      size        = d.size_mb / 1000
      mount_point = d.description
      speed       = d.custom_fields["speed"]
      emulate_ssd = d.custom_fields["ssd"] == "y" ? true : false
    }
  ]
}

data "netbox_devices" "lookup" {
  filter {
    name  = "cluster_id"
    value = data.netbox_cluster.lookup.id
  }
  limit = 1
}