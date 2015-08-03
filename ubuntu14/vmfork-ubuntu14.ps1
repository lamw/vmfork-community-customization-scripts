# William Lam
# www.virtuallyghetto.com
# Driver script to Instant Clone Ubuntu 14.x VMs

Import-Module VMware.VimAutomation.Extensions

$session = Connect-VIServer -Server 192.168.1.60 -User administrator@vghetto.local -Password VMware1!

$parentvm = 'Ubuntu'
$parentvm_username = 'root'
$parentvm_password = 'vmware123'
$precust_script = 'C:\Users\lamw\Desktop\vmfork\pre-ubuntu14.sh'
$postcust_script = 'C:\Users\lamw\Desktop\vmfork\post-ubuntu14.sh'

# Quiesce ParentVM
Write-Host "Quiescing ParentVM: $parentvm ..."
$quiesceParentVM = Enable-InstantCloneVM -VM "$parentvm" -GuestUser "$parentvm_username" -GuestPassword "$parentvm_password" -PreQuiesceScript "$precust_script" -PostCloneScript "$postcust_script" -Confirm:$false

# Create 5 Instant Clone VMs
# 192.168.1.140 - 192.168.1.144
140..144 | Foreach {
	# Name of the IC VM
	$vmname = "ubuntu-ic-$_"

	# Instant Clone configurations to pass to guestOS
	$configSettings = @{
		'hostname' = "$vmname.primp-industries";
		'ipaddress' = "192.168.1.$_";
		'netmask' = '24';
		'gateway' = '192.168.1.1';
	}
	Write-Host "Creating Instant Clone: $vmname ("$configSettings.ipaddress") ..."
	$forkedChildVM = New-InstantCloneVM -ParentVM $quiesceParentVM -Name $vmname -ConfigParams $configSettings
	Write-Host "`tPowering on $vmname ..."
	$forkedChildVM | Start-Vm -RunAsync | Out-Null
}
Write-Host

Disconnect-VIServer -Server $session -Confirm:$false
