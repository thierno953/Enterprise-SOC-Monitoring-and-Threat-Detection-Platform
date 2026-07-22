<#
.SYNOPSIS
Install and configure Sysmon for SOC monitoring

.DESCRIPTION
Downloads Microsoft Sysmon and deploys a custom configuration
for advanced Windows telemetry collection used by SIEM monitoring.
#>

$SysmonUrl = "https://download.sysinternals.com/files/Sysmon.zip"
$InstallPath = "C:\Tools\Sysmon"
$ConfigFile = "$InstallPath\sysmon-config.xml"

Write-Host "[+] Creating installation directory..."

New-Item `
-Path $InstallPath `
-ItemType Directory `
-Force | Out-Null


Write-Host "[+] Downloading Sysmon..."

Invoke-WebRequest `
-Uri $SysmonUrl `
-OutFile "$InstallPath\Sysmon.zip"


Write-Host "[+] Extracting Sysmon..."

Expand-Archive `
-Path "$InstallPath\Sysmon.zip" `
-DestinationPath $InstallPath `
-Force


$SysmonExe = "$InstallPath\Sysmon64.exe"


if (!(Test-Path $SysmonExe)) {
    Write-Host "[!] Sysmon executable not found"
    exit 1
}


if (!(Test-Path $ConfigFile)) {
    Write-Host "[!] Sysmon configuration file missing:"
    Write-Host $ConfigFile
    exit 1
}


Write-Host "[+] Installing Sysmon..."

Start-Process `
-FilePath $SysmonExe `
-ArgumentList "-i $ConfigFile -accepteula" `
-Wait


Write-Host "[+] Verifying Sysmon installation..."

$Service = Get-Service -Name Sysmon64 -ErrorAction SilentlyContinue

if ($Service) {
    Write-Host "[+] Sysmon service installed successfully"
    Write-Host "    Status: $($Service.Status)"
}
else {
    Write-Host "[!] Sysmon service not detected"
}


Write-Host "[+] Sysmon deployment completed"