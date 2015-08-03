# William Lam
# www.virtuallyghetto.com
# Instant Clone Pre Customization Script
#   OS: Ubuntu 14.04.1 LTS (GNU/Linux 3.13.0-32-generic x86_64)

set -x

echo "Start of pre ..."

# Removing any existing DHCP leases
rm -f /var/lib/dhcp/dhclient.*

# Stop Networking
/etc/init.d/networking stop

echo "End of pre ..."
