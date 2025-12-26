locals {
  platforms = {
    debian-12 = {
      name      = "Debian 12"
      tag       = "debian"
      type      = "l26"
      iso       = "debian_12.1.0_netinst.iso"
      lxc_image = "local:vztmpl/debian-12-standard_12.2-1_amd64.tar.zst"
      uefi      = false
      virtio    = true
      cpu       = "host"
    }
    debian-13 = {
      name      = "Debian 13"
      tag       = "debian"
      type      = "l26"
      iso       = "debian_13.2.0_netinst.iso"
      lxc_image = ""
      uefi      = false
      virtio    = true
      cpu       = "host"
    }
    red-hat-enterprise-linux-9 = {
      name      = "Red Hat Enterprise Linux 9"
      tag       = "red-hat-enterprise-linux"
      type      = "l26"
      iso       = "rhel_9.3.iso"
      lxc_image = ""
      uefi      = false
      virtio    = true
      cpu       = "host"
    }
    vyos = {
      name      = "VyOS"
      tag       = "vyos"
      type      = "l26"
      iso       = "vyos_1.4_rolling.iso"
      lxc_image = ""
      uefi      = false
      virtio    = true
      cpu       = "host"
    }
    windows-posready-2009 = {
      name      = "Windows POSReady 2009"
      tag       = "windows-2009"
      type      = "wxp"
      iso       = "windows_pos_2009.iso"
      lxc_image = ""
      uefi      = false
      virtio    = false
      cpu       = "host"
    }


    unknown = {
      name      = "Unmapped"
      tag       = "unknown"
      type      = "l26"
      iso       = ""
      lxc_image = ""
      uefi      = false
      virtio    = false
      cpu       = "host"
    }
  }
}