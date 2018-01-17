Import-Module Hyper-V

Write-Host Checking tugboat Hyper-V VMSwitch configuration...

if ((Get-VMSwitch -Name Tugboat -ErrorAction SilentlyContinue).Name -eq $null) {
  Write-Host No tugboat Hyper-V VMSwitch present. Creating one now...
  New-VMSwitch -Name Tugboat -SwitchType Internal -Notes 'Added by tugboat to route your docker containers' | Out-Null
  Write-Host SUCCESS!
}

if ((Get-NetIPAddress -IPAddress 10.156.156.1 -ErrorAction SilentlyContinue).InterfaceAlias -eq $null) {
  Write-Host Tugboat IP address not configured. Configuring now...
  $ifIndex = $(Get-NetAdapter | Where-Object { $_.Name -eq "vEthernet (Tugboat)" } ).ifIndex
  New-NetIPAddress -InterfaceIndex $ifIndex -IPAddress 10.156.156.1 -PrefixLength 24 | Out-Null
  Write-Host SUCCESS!
}

Write-Host Tugboat Hyper-V VMSwitch configured!