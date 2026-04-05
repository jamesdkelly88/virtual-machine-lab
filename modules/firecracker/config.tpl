{
  "boot-source": {
    "kernel_image_path": "../../kernel/${kernel}/vmlinux.bin",
    "boot_args": "console=ttyS0 reboot=k panic=1 pci=off overlay_root=vdb init=/sbin/overlay-init",
    "initrd_path": null
  },
  "drives": [
    {
      "drive_id": "rootfs",
      "partuuid": null,
      "is_root_device": true,
      "cache_type": "Unsafe",
      "is_read_only": true,
      "path_on_host": "../../rootfs/${os}.img",
      "io_engine": "Sync",
      "rate_limiter": null,
      "socket": null
    },
    {
      "drive_id": "overlayfs",
      "path_on_host": "overlay.ext4",
      "is_root_device": false,
      "partuuid": null,
      "is_read_only": false,
      "cache_type": "Unsafe",
      "rate_limiter": null
    }
  ],
  "machine-config": {
    "vcpu_count": ${cpu},
    "mem_size_mib": ${memory},
    "smt": false,
    "track_dirty_pages": false,
    "huge_pages": "None"
  },
  "cpu-config": null,
  "balloon": null,
  "network-interfaces": [
    {
      "iface_id": "eth0",
      "guest_mac": "${mac}",
      "host_dev_name": "tap${id}"
    }
  ],
  "vsock": null,
  "logger": null,
  "metrics": null,
  "mmds-config": null,
  "entropy": null,
  "pmem": [],
  "memory-hotplug": null
}