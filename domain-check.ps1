<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2018 v5.5.151
	 Created on:   	10/09/2018 10:10 AM
	 Created by:   	Kiren James
	 Organization: 	Zone24x7
	 Filename:     	Check.ps1
	===========================================================================
	.DESCRIPTION
		A description of the file.
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
Write-Output "Commands completed successfully" 
# cmd /c pause comment in app
Exit