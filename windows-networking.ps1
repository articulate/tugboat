Import-Module Hyper-V

if ((Get-VMSwitch -Name Tugboat).Name -eq $null) {
  New-VMSwitch -Name Tugboat -SwitchType Internal -Notes 'Added by tugboat to route your docker containers'
}
if ((Get-NetIPAddress -IPAddress 10.156.156.1).InterfaceAlias -eq $null) {
  $ifIndex = $(Get-NetAdapter | Where-Object { $_.Name -eq "vEthernet (Tugboat)" } ).ifIndex
  New-NetIPAddress -InterfaceIndex $ifIndex -IPAddress 10.156.156.1 -PrefixLength 24
}
