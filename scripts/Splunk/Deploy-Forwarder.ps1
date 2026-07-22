<#
.SYNOPSIS
Deploy Splunk Universal Forwarder

.DESCRIPTION
Installs Splunk Universal Forwarder and configures
Windows telemetry forwarding to the SOC SIEM.
#>


$SplunkServer = "192.168.20.5:9997"
$Installer = ".\splunkforwarder.msi"

$SplunkPath = "C:\Program Files\SplunkUniversalForwarder\bin"


Write-Host "[+] Installing Splunk Universal Forwarder"


if (!(Test-Path $Installer)) {
    Write-Host "[!] Installer not found"
    exit 1
}


Start-Process msiexec.exe `
-ArgumentList "/i $Installer AGREETOLICENSE=Yes /quiet" `
-Wait


if (!(Test-Path $SplunkPath)) {

    Write-Host "[!] Splunk installation failed"
    exit 1

}


Write-Host "[+] Configuring forwarding"


& "$SplunkPath\splunk.exe" add forward-server `
$SplunkServer `
-auth admin:<ENTERPRISE_PASSWORD>


Write-Host "[+] Configuring Windows logs"


& "$SplunkPath\splunk.exe" add monitor `
"WinEventLog://Security"


& "$SplunkPath\splunk.exe" add monitor `
"WinEventLog://System"


& "$SplunkPath\splunk.exe" add monitor `
"WinEventLog://Application"


Write-Host "[+] Adding Sysmon telemetry"


& "$SplunkPath\splunk.exe" add monitor `
"WinEventLog://Microsoft-Windows-Sysmon/Operational"


Write-Host "[+] Enabling Splunk service"


& "$SplunkPath\splunk.exe" enable boot-start


Write-Host "[+] Restarting Splunk Forwarder"


& "$SplunkPath\splunk.exe" restart


Write-Host "[+] Splunk Universal Forwarder deployment completed"