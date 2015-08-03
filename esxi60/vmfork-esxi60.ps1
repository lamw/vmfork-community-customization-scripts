# William Lam
# www.virtuallyghetto.com
# Driver script for Instant Cloning Nested ESXi 6.x VMs

Import-Module VMware.VimAutomation.Extensions

$session = Connect-VIServer -Server 192.168.1.60 -User administrator@vghetto.local -Password VMware1!

$parentvm = 'vESXi6'
$parentvm_username = 'root'
$parentvm_password = 'vmware123'
$precust_script = 'C:\Users\lamw\Desktop\vmfork\esxi60\pre-esxi60.sh'
$postcust_script = 'C:\Users\lamw\Desktop\vmfork\esxi60\post-esxi60.sh'

# Quiesce ParentVM
Write-Host "Quiescing ParentVM: $parentvm ..."
$quiesceParentVM = Enable-InstantCloneVM -VM "$parentvm" -GuestUser "$parentvm_username" -GuestPassword "$parentvm_password" -PreQuiesceScript "$precust_script" -PostCloneScript "$postcust_script" -Confirm:$false

# Create 5 Instant Clone VMs
# 192.168.1.120 - 192.168.1.124
120..124 | Foreach {
	# Name of the IC VM
	$vmname = "esxi6-ic-$_"

	# Instant Clone configurations to pass to guestOS
	$configSettings = @{
		'hostname' = "$vmname.primp-industries";
		'ipaddress' = "192.168.1.$_";
		'netmask' = '255.255.255.0';
		'gateway' = '192.168.1.1';
	}
	Write-Host "Creating Instant Clone: $vmname ("$configSettings.ipaddress") ..."
	$forkedChildVM = New-InstantCloneVM -ParentVM $quiesceParentVM -Name $vmname -ConfigParams $configSettings
	Write-Host "`tPowering on $vmname ..."
	$forkedChildVM | Start-Vm -RunAsync | Out-Null
}
Write-Host

Disconnect-VIServer -Server $session -Confirm:$false
