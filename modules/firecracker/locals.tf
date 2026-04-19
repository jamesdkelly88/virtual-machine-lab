locals {

  args_linux     = "overlay_root=vdb init=/sbin/overlay-init pci=off"
  args_talos     = "talos.platform=metal pti=on slab_nomerge pci=on"
  is_talos       = startswith(var.os, "talos-")
  kernel_version = "6.1.155"
  kernel = lookup({
    hello = "hello"
  }, var.os, local.kernel_version)
}