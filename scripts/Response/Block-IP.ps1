<#
.SYNOPSIS
Block malicious IP using pfSense

.DESCRIPTION
Automated containment action triggered after high-risk SIEM detection.
Creates a firewall block rule on pfSense.
#>

param(
    [Parameter(Mandatory=$true)]
    [ValidatePattern(
        '^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$'
    )]
    [string]$IPAddress
)


$Firewall = "192.168.20.1"
$LogFile = "C:\SOC\containment-actions.log"


$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"


Write-Host "[+] Blocking malicious IP: $IPAddress"


$Command = "easyrule block wan $IPAddress"


$result = ssh admin@$Firewall $Command


if ($LASTEXITCODE -eq 0) {

    Write-Host "[+] Firewall rule applied"

    Add-Content `
    -Path $LogFile `
    -Value "$Timestamp BLOCKED $IPAddress"

}
else {

    Write-Host "[!] Firewall action failed"

    Add-Content `
    -Path $LogFile `
    -Value "$Timestamp FAILED $IPAddress"

    exit 1
}


Write-Host "[+] Containment completed"