#!/bin/ash
# William Lam
# www.virtuallygheto.com
# Script to prepare Nested ESXi VM for Instant Clone

# Stop hostd
/etc/init.d/hostd stop

# Remove any exisitng VMkernel interfaces which would have associationg with existing MAC Addresses
localcli network ip interface remove -i vmk0
localcli network vswitch standard portgroup remove -p "Management Network" -v "vSwitch0"

# Unload networking + vmfs3 modules which also contains system UUID mappings
vmkload_mod -u vmfs3
vmkload_mod -u vmxnet3

# Ensure the new MAC Address is automatically picked up once cloned
localcli system settings advanced set -o /Net/FollowHardwareMac -i 1

# Remove any potential old DHCP leases
rm -f /etc/dhclient*leases

# Ensure new system UUID is generated
sed -i 's#/system/uuid.*##g' /etc/vmware/esx.conf
