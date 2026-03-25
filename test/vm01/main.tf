module "firecracker" {
  source      = "../../modules/firecracker"
  cpu         = 2
  description = "Alpine Hello World"
  id          = 1
  memory      = 1
  name        = "vm01"
  networks = [{
    domain      = false
    id          = 0
    mac_address = "00:de:ad:be:ef:01"
    name        = "eth0"
  }]
}