resource "system_folder" "vm" {
  path  = "/opt/firecracker/vm/${var.name}"
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
    mac    = var.networks[0].mac_address
    memory = var.memory * 1024
  })
}

# TODO: system_command to copy kernel and rootfs if they don't already exist 

# TODO: system_file and template for service
resource "system_file" "service" {
  path  = "/usr/lib/systemd/system/${var.name}.service"
  user  = "root"
  group = "root"
  mode  = 644
  content = templatefile("${path.module}/service.tpl", {
    name        = var.name
    description = var.description
  })
}

# TODO: system_systemd_unit for service