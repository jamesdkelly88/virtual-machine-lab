locals {
  bridge = [for each in data.virtualbox_network.this.bridged_interfaces : each.name if startswith(each.ipv4_address,"192.168.")][0]
  controller_attach = var.interface == "ide" ? [] : local.disk_attach_xml
  controller_flags = {
    sata = "IDE0MasterEmulationPort=\"0\" IDE0SlaveEmulationPort=\"1\" IDE1MasterEmulationPort=\"2\" IDE1SlaveEmulationPort=\"3\""
    scsi = ""
    virtio = ""
  }
  controller_name = {
    sata = "SATA"
    scsi = "LsiLogic"
    virtio = "VirtIO"
  }
  controller_ports = {
    sata = 4
    scsi = 16
    virtio = 4
  }
  controller_type = {
    sata = "AHCI"
    scsi = "LsiLogic"
    virtio = "VirtioSCSI"
  }
  disk_attach_xml = [for d in var.storage : "          <AttachedDevice type=\"HardDisk\" hotpluggable=\"false\" port=\"${ d.id }\" device=\"0\">\n            <Image uuid=\"{${ virtualbox_disk.this[d.id].id }}\"/>\n          </AttachedDevice>" ]
  disk_xml = [for d in var.storage : "        <HardDisk uuid=\"{${ virtualbox_disk.this[d.id].id }}\" location=\"${ var.name }_${ d.id }.vdi\" format=\"VDI\" type=\"Normal\"/>" ]
  ide_attach = var.interface == "ide" ? concat(local.disk_attach_xml, local.iso_attach_xml) : local.iso_attach_xml
  interface = var.interface == "ide" ? "sata" : var.interface
  is_windows = length(regexall("^[a-z]:", lower(abspath(path.root)))) > 0
  iso_attach_xml = [for i in local.isos : "          <AttachedDevice passthrough=\"false\" type=\"DVD\" hotpluggable=\"false\" port=\"${ index(local.isos,i) + local.iso_port }\" device=\"0\">\n            <Image uuid=\"{${ random_uuid.iso[i].result }}\"/>\n          </AttachedDevice>" ]
  iso_path = local.is_windows ? "//ns01/iso/" : "TBC"
  iso_port = var.interface == "ide" ? 2 : 0
  iso_xml = [for i in local.isos : "        <Image uuid=\"{${ random_uuid.iso[i].result }}\" location=\"${ i }.iso\"/>" ]
  isos = concat(["${ local.iso_path }${ var.iso }"], var.iso2 == "" ? [] : [ "${ local.iso_path }${ var.iso2 }" ])
  nic_xml = [for n in var.networks : "        <Adapter slot=\"${ n.id }\" enabled=\"true\" MACAddress=\"${ upper(replace(n.mac_address,":","")) }\" promiscuousModePolicy=\"AllowAll\" type=\"82540EM\">\n          <DisabledModes>\n            <NAT localhost-reachable=\"true\"/>\n            <InternalNetwork name=\"intnet\"/>\n            <NATNetwork name=\"NatNetwork\"/>\n          </DisabledModes>\n          <BridgedInterface name=\"${ local.bridge }\"/>\n         </Adapter>" ]
  os_map = {
    l24	= "Linux24_64"
    l26	= "Linux_64"
    other = "Other_64"
    solaris	= "Solaris11_64"
    w2k = "Windows2000"
    w2k3 = "Windows2003_64"
    w2k8 = "Windows2008_64"
    win10	= "Windows10_64"
    win11	= "Windows11_64"
    win7 = "Windows7_64"
    win8 = "Windows8_64"
    wvista = "WindowsVista_64"
    wxp	= "WindowsXP"
  }
  vm_path = local.is_windows ? "C:\\VMs\\${ var.name }\\" : "TBC"
}