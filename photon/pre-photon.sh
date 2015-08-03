# William Lam
# www.virtuallyghetto.com
# Instant Clone Pre Customization Script
#   OS: Linux photon 3.19.2 #1-photon SMP Wed Apr 15 22:37:11 UTC 2015 x86_64 GNU/Linux

set -x

echo "Start of pre ..."

# Enable root login for SSH
sed -i 's/Permit.*//g' /etc/ssh/sshd_config
systemctl restart sshd

# Disable eth0
echo "Disabling eth0 interface ..."
mv /etc/systemd/network/10-dhcp-eth0.network /etc/systemd/network/10-dhcp-eth0.network.bak
ip link set eth0 down

echo "End of pre ..."
