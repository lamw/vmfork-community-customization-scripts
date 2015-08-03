# William Lam
# www.virtuallyghetto.com
# Instant Clone Post Customization Script
#   OS: Ubuntu 14.04.1 LTS (GNU/Linux 3.13.0-32-generic x86_64)

set -x

echo "Start of post ..."

# retrieve networking info passed from script
HOSTNAME=$(vmware-rpctool "info-get guestinfo.fork.hostname")
IP_ADDRESS=$(vmware-rpctool "info-get guestinfo.fork.ipaddress")
NETMASK=$(vmware-rpctool "info-get guestinfo.fork.netmask")
GATEWAY=$(vmware-rpctool "info-get guestinfo.fork.gateway")

echo "Updating MAC Address ..."
if lsmod | grep vmxnet3 > /dev/null 2>&1 ; then
	NIC_MODULE=vmxnet3
elif lsmod | grep e1000e > /dev/null 2>&1 ; then
	NIC_MODULE=e1000e
elif lsmod | grep e1000 > /dev/null 2>&1 ; then
	NIC_MODULE=e1000
fi
modprobe -r ${NIC_MODULE};modprobe ${NIC_MODULE}

echo "Updating IP Address ..."
ip addr add ${IP_ADDRESS}/${NETMASK} dev eth0
ip link set eth0 up

echo "Updating Hostname ..."
hostnamectl set-hostname ${HOSTNAME}

echo "Enabling networking ..."
/etc/init.d/networking start

echo "Updating Hardware Clock on the system ..."
hwclock --hctosys

echo "End of post ..."
