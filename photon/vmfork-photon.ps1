# William Lam
# www.virtuallyghetto.com
# Driver script to Instant Clone Photon VMs

Import-Module VMware.VimAutomation.Extensions

$vcserver = "192.168.1.150"
$vcusername = "administrator@vghetto.local"
$vcpassword = "VMware1!"
Connect-VIServer -Server $vcserver -User $vcusername -Password $vcpassword

$parentvm = 'Photon'
$parentvm_username = 'root'
$parentvm_password = '!VMware123!'
$precust_script = 'C:\Users\lamw\Desktop\vmfork\photon\pre-photon.sh'
$postcust_script = 'C:\Users\lamw\Desktop\vmfork\photon\post-photon.sh'

# Quiesce ParentVM
Write-Host "Quiescing ParentVM: $parentvm ..."
$quiesceParentVM = Enable-InstantCloneVM -VM "$parentvm" -GuestUser "$parentvm_username" -GuestPassword "$parentvm_password" -PreQuiesceScript "$precust_script" -PostCloneScript "$postcust_script" -Confirm:$false

# Create 5 Instant Clone VMs
# 192.168.1.150 - 192.168.1.154
150..154 | Foreach {
	# Name of the IC VM
	$vmname = "photon-ic-$_"

	# Instant Clone configurations to pass to guestOS
	$configSettings = @{
		'hostname' = "$vmname.primp-industries";
		'ipaddress' = "192.168.1.$_";
		'netmask' = '24';
		'gateway' = '192.168.1.1';
		'dns' = '192.168.1.1'
	}
	Write-Host "Creating Instant Clone: $vmname ("$configSettings.ipaddress") ..."
	$forkedChildVM = New-InstantCloneVM -ParentVM $quiesceParentVM -Name $vmname -ConfigParams $configSettings
	Write-Host "`tPowering on $vmname ..."
	$forkedChildVM | Start-Vm -RunAsync | Out-Null
}
Write-Host

Disconnect-VIServer -Server $vcserver -Confirm:$false
