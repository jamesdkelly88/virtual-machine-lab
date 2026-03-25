module "firecracker" {
  source      = "../../modules/firecracker"
  cpu         = 2
  description = "Alpine Hello World"
  id          = 0
  memory      = 1
  name        = "vm00"
  networks = [{
    domain      = false
    id          = 0
    mac_address = "00:de:ad:be:ef:00"
    name        = "eth0"
  }]
}