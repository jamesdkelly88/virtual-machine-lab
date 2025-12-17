locals {
  platforms = {
    debian-12 = {
      name      = "Debian 12"
      type      = "l26"
      iso       = "debian_12.1.0_netinst.iso"
      lxc_image = "local:vztmpl/debian-12-standard_12.2-1_amd64.tar.zst"
      uefi      = false
      virtio    = true
      cpu       = "host"
    }
    red-hat-enterprise-linux-9 = {
      name      = "Red Hat Enterprise Linux 9"
      type      = "l26"
      iso       = "rhel_9.3.iso"
      lxc_image = ""
      uefi      = false
      virtio    = true
      cpu       = "host"
    }
    vyos = {
      name      = "VyOS"
      type      = "l26"
      iso       = "vyos_1.4_rolling.iso"
      lxc_image = ""
      uefi      = false
      virtio    = true
      cpu       = "host"
    }




    unknown = {
      name      = "Unmapped"
      type      = "l26"
      iso       = ""
      lxc_image = ""
      uefi      = false
      virtio    = false
      cpu       = "host"
    }
  }
}