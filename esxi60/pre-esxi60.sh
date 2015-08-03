# William Lam
# www.virtuallyghetto.com
# Instant Clone Pre Customization Script
#   OS: ESXi 6.0

set -x

echo "Start of pre ..."

# Setup path to vmtoolsd to so quiesce operation
export LD_LIBRARY_PATH=/usr/lib/vmware/vmtools/lib:$LD_LIBRARY_PATH
export PATH=/usr/lib/vmware/vmtools/bin:$PATH

echo "End of pre ..."
