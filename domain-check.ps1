<#	
	.NOTES
	===========================================================================
	 Created with: 	PowerShellGUI
	 Created on:   	10/09/2018 10:10 AM
	 Created by:   	Kiren James
	 Organization: 	Atom Inc
	 Filename:     	domain-check.ps1
	===========================================================================
	.DESCRIPTION
		A script to check the initial domain setup of a windows client.
#>
Write-Output "Domain Connected :"
$domainbool = (Get-WmiObject -Class Win32_ComputerSystem).PartOfDomain
Write-Output $domainbool
if ($domainbool)
{
	Write-Output " "
	Write-Output "Current Domain :"
	(Get-WmiObject win32_computersystem).Domain
}
else
{
	Write-Output " "
	Write-Output "Current Workgroup :"
	(Get-WmiObject win32_computersystem).Domain
}
Write-Output " "
Write-Output "Current Computer Name :"
(Get-WmiObject win32_computersystem).name
Write-Output " "
Write-Output "Current Users :"
invoke-command {
    net localgroup administrators | 
    where {$_ -AND $_ -notmatch "command completed successfully"} | 
    select -skip 4
}
Write-Output " "
Write-Output "Windows Activation Status :"
cscript C:\Windows\System32\slmgr.vbs (Get-WmiObject win32_computersystem).name /dli
Write-Output " "
Write-Output "Windows Version :"
(Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name ReleaseID -ErrorAction Stop).ReleaseID
Write-Output " "
Write-Output "Office Activation Status :"
$officePath = "C:\Program Files\Microsoft Office\Office16\ospp.vbs"
if ([System.IO.File]::Exists($officePath))
{
	CD $officePath
}
else
{
	CD "C:\Program Files (x86)\Microsoft Office\Office16\"
}
cscript ospp.vbs /dstatus
Write-Output " "
Write-Output "Installed Software :"
Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object @{ n='Software'; e={ $_.DisplayName } } | Format-Table –AutoSize
Write-Output " "
Write-Output "Commands completed successfully"
cmd /c pause