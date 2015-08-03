# William Lam
# www.virtuallyghetto.com
# Instant Clone Post Customization Script
#   OS: ESXi 6.0

set -x

echo "Start of post ..."

# setups path for vmtoolsd
export LD_LIBRARY_PATH=/usr/lib/vmware/vmtools/lib:$LD_LIBRARY_PATH
export PATH=/usr/lib/vmware/vmtools/bin:$PATH

# temp resource group
RESOURCE_GRP='++group=host/vim/tmp'

# retrieve networking info passed from script
hostname=$(vmtoolsd ${RESOURCE_GRP} --cmd "info-get guestinfo.fork.hostname")
ipaddress=$(vmtoolsd ${RESOURCE_GRP} --cmd "info-get guestinfo.fork.ipaddress")
netmask=$(vmtoolsd ${RESOURCE_GRP} --cmd "info-get guestinfo.fork.netmask")
gateway=$(vmtoolsd ${RESOURCE_GRP} --cmd "info-get guestinfo.fork.gateway")

# load networking module
vmkload_mod ${RESOURCE_GRP} vmxnet3

# setups VMK0
localcli ${RESOURCE_GRP} network vswitch standard portgroup add -p "Management Network" -v "vSwitch0"
localcli ${RESOURCE_GRP} network ip interface add -i vmk0 -p "Management Network"
localcli ${RESOURCE_GRP} network ip interface ipv4 set -i vmk0 -I ${ipaddress} -N ${netmask} -t static
localcli ${RESOURCE_GRP} system hostname set -f ${hostname}
localcli ${RESOURCE_GRP} network ip route ipv4 add -g ${gateway} -n default

# load vmfs3 module
vmkload_mod ${RESOURCE_GRP} vmfs3

# Start hostd
/etc/init.d/hostd start &

echo "End of post ..."
