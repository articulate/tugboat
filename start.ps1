If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
  $scriptDir = Split-Path $MyInvocation.MyCommand.Path -Parent

  $arguments = "& '" + $scriptDir + "/windows-networking.ps1'"
  $p = Start-Process powershell -Verb runAs -ArgumentList $arguments -wait
  $p.HasExited
  $p.ExitCode
}

setx TUGBOAT_IP=10.156.156.1
set TUGBOAT_IP=10.156.156.1

docker-compose stop
docker-compose rm -f
docker-compose build
docker-compose up
