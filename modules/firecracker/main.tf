resource "system_folder" "vm" {
  path  = "/opt/firecracker/vm/${var.id}"
  user  = "firecracker"
  group = "firecracker"
}

resource "system_file" "tap" {
  path  = "/etc/network/interfaces.d/tap${var.id}"
  user  = "root"
  group = "root"
  content = templatefile("${path.module}/tap.tpl", {
    id     = var.id
    bridge = "br0" # TODO: domain selector
  })
}

data "system_command" "ifup" {
  command = "ifup tap${var.id}"

  depends_on = [system_file.tap]
}

resource "system_file" "config" {
  path  = "${system_folder.vm.path}/config.json"
  user  = "firecracker"
  group = "firecracker"
  # TODO: jsonencode object
  content = templatefile("${path.module}/config.tpl", {
    cpu    = var.cpu
    id     = var.id
    kernel = local.kernel
    mac    = var.networks[0].mac_address
    memory = var.memory * 1024
    os     = var.os
  })
}

# TODO: system_command to create overlay.ext4 if it doesn't exist
data "system_command" "overlay" {
  command    = "if ! test -f ${system_folder.vm.path}/overlay.ext4; then\ndd if=/dev/zero of=${system_folder.vm.path}/overlay.ext4 conv=sparse bs=1 count=0 seek=${1024 * var.storage[0].size}M\nmkfs.ext4 ${system_folder.vm.path}/overlay.ext4\nchown firecracker:firecracker ${system_folder.vm.path}/overlay.ext4\nfi"
  depends_on = [system_folder.vm]
}

resource "system_file" "service" {
  path  = "/usr/lib/systemd/system/${var.name}.service"
  user  = "root"
  group = "root"
  mode  = 644
  content = templatefile("${path.module}/service.tpl", {
    id          = var.id
    name        = var.name
    description = var.description
  })
}