auto tap${id}
iface tap${id} inet manual
  pre-up /sbin/ip tuntap add mode tap user firecracker name $IFACE || true
  pre-up /sbin/ip link set dev $IFACE master ${bridge}
  up /sbin/ip link set dev $IFACE up
  post-down /sbin/ip link del dev $IFACE || true
