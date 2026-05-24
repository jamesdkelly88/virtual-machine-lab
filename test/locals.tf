locals {
  is_windows = length(regexall("^[a-z]:", lower(abspath(path.root)))) > 0
  iso_path = local.is_windows ? "\\\\ns01\\iso\\" : "TBC"
  isos = concat(["${ local.iso_path }${ var.iso }"], var.iso2 == "" ? [] : [ "${ local.iso_path }${ var.iso2 }" ])
  nic = [for each in data.virtualbox_network.this.bridged_interfaces : each.name if startswith(each.ipv4_address,"192.168.")][0]
  vdi_path = local.is_windows ? "C:\\VMs\\" : "TBC"
}