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

data "netbox_ip_addresses" "lookup" {
  for_each = { for i in data.netbox_interfaces.lookup.interfaces : i.id => i }

  filter {
    name  = "vm_interface_id"
    value = each.key
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
      ip_address  = split("/", data.netbox_ip_addresses.lookup[i.id].ip_addresses[0].ip_address)[0]
      domain      = substr(data.netbox_ip_addresses.lookup[i.id].ip_addresses[0].ip_address, 0, 11) != "192.168.90."
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