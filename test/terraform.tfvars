cpu = 1
interface = "sata"
iso = "alpine_3.23.3"
iso2 = ""
memory = 2
name = "vm03"
networks = [
    {
        id = 0
        mac_address = "00:de:ad:be:ef:03"
        name = "eth0"
        domain = false
    },
    {
        id = 1
        mac_address = "01:de:ad:be:ef:03"
        name = "eth1"
        domain = false
    }
]
os_type = "l26"
storage = [
    {
        emulate_ssd = false
        id = 0
        mount_point = "/"
        size = 8
        speed = "slow"
    },
    {
        emulate_ssd = false
        id = 1
        mount_point = "/test"
        size = 8
        speed = "slow"
    }
]
uefi = false