locals {
  rootfs = {
    drive_id       = "rootfs"
    partuuid       = null
    is_root_device = true
    cache_type     = "Unsafe"
    is_read_only   = true
    path_on_host   = "/mnt/hdd/rootfs/${var.os}.img"
    io_engine      = "Sync"
    rate_limiter   = null
    socket         = null
  }
  overlayfs = {
    drive_id       = "overlayfs"
    path_on_host   = "overlay.ext4"
    is_root_device = local.is_talos
    partuuid       = null
    is_read_only   = false
    cache_type     = "Unsafe"
    rate_limiter   = null
  }

  # TODO: additional disks here

  drives = local.is_talos ? [local.overlayfs] : [local.rootfs, local.overlayfs]
  network_interfaces = [
    {
      iface_id      = "eth0"
      guest_mac     = var.networks[0].mac_address
      host_dev_name = "tap${var.id}"
    }
  ]

  config = {
    boot-source = {
      kernel_image_path = "/mnt/hdd/kernel/vmlinux-${local.is_talos ? var.os : local.kernel}.bin"
      boot_args         = "console=ttyS0 reboot=k panic=1 ${local.is_talos ? local.args_talos : local.args_linux}"
      initrd_path       = local.is_talos ? "/mnt/hdd/rootfs/${var.os}.xz" : null
    }
    drives = local.drives
    machine-config = {
      vcpu_count        = var.cpu
      mem_size_mib      = var.memory * 1024
      smt               = false
      track_dirty_pages = false
      huge_pages        = "None"
    }
    cpu-config         = null
    balloon            = null
    network-interfaces = local.network_interfaces
    vsock              = null
    logger             = null
    metrics            = null
    mmds-config        = null
    entropy            = null
    pmem               = []
    memory-hotplug     = null
  }
}