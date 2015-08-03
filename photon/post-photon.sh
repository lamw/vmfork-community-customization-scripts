# William Lam
# www.virtuallyghetto.com
# Instant Clone Post Customization Script
#   OS: Linux photon 3.19.2 #1-photon SMP Wed Apr 15 22:37:11 UTC 2015 x86_64 GNU/Linux

set -x

echo "Start of post ..."

# retrieve networking info passed from script
HOSTNAME=$(vmware-rpctool "info-get guestinfo.fork.hostname")
IP_ADDRESS=$(vmware-rpctool "info-get guestinfo.fork.ipaddress")
NETMASK=$(vmware-rpctool "info-get guestinfo.fork.netmask")
GATEWAY=$(vmware-rpctool "info-get guestinfo.fork.gateway")
DNS=$(vmware-rpctool "info-get guestinfo.fork.dns")

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
cat > /etc/systemd/network/10-static-eth0.network << PHOTON_NET
[Match]
Name=eth0

[Network]
Address=${IP_ADDRESS}/${NETMASK}
Gateway=${GATEWAY}
DNS=${DNS}
Domains=${HOSTNAME}
PHOTON_NET

echo "Enabling eth0 interface ..."
ip link set eth0 up

echo "Updating Hostname ..."
hostnamectl set-hostname ${HOSTNAME}

echo "Enabling networking ..."
systemctl restart systemd-networkd.service

echo "Updating Hardware Clock on the system ..."
hwclock --hctosys

echo "End of post ..."
