#Requires -Version 4
#Requires -RunAsAdministrator

<#
Script to connect to StorSimple 8k series via Powershell 
and obtain its IP information including MAC addresses
Script by Sam Boutros, 20 June 2016, v1.0
#>

#region Input

$StorSimpleIP = '10.4.12.70'

#endregion

# Add StorSimple array to list of trusted hosts on this management computer
Set-Item wsman:\localhost\Client\TrustedHosts $StorSimpleIP -Concatenate -Force


# Get pwd for SSAdmin, store in encrypted local file for future automation
if (!(Test-Path -Path ".\SSCred.txt")) {
    Read-Host 'Enter the pwd for your StorSimple administration' -AsSecureString | ConvertFrom-SecureString | Out-File .\SSCred.txt
}
$Pwd    = Get-Content .\SSCred.txt | ConvertTo-SecureString 
$SSCred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "$StorSimpleIP\ssadmin", $Pwd

# Open PS session if one is not open already
$StorSimpleSession = Get-PSSession | where { $_.ComputerName -eq $StorSimpleIP }
if (! $StorSimpleSession) { $StorSimpleSession = New-PSSession -ComputerName $StorSimpleIP -Credential $SSCred -ConfigurationName SSAdminConsole }

$IPs  = Invoke-Command -Session $StorSimpleSession { Get-HcsNetInterface }

$MACs = Invoke-Command -Session $StorSimpleSession { Get-NetAdapter } 

# Stitch them together:
$StorSimpleInterfaces = @()
$IPs | where { $_.IPv4Address } | % {
    $InterfaceName = $_.InterfaceAlias
    $Splatt = [ordered]@{
        InterfaceName  = $InterfaceName
        IPv4Address    = $_.IPv4Address
        IPv4Netmask    = $_.IPv4Netmask
        IPv4Gateway    = $_.IPv4Gateway
        MACAddress     = ($MACs | where { $InterfaceName -eq $_.Name } ).MacAddress
        IsEnabled      = $_.IsEnabled
        IsCloudEnabled = $_.IsCloudEnabled
        IsiSCSIEnabled = $_.IsiSCSIEnabled
    }
    $StorSimpleInterfaces += New-Object -TypeName PSObject -Property $Splatt
}
$StorSimpleInterfaces | sort InterfaceName | FT -a 