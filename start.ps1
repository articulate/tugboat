$scriptDir = Split-Path $MyInvocation.MyCommand.Path -Parent

$arguments = "& '" + $scriptDir + "/windows-networking.ps1'"
$p = Start-Process powershell -Verb runas -ArgumentList $arguments -Wait
$p.HasExited
$p.ExitCode

Set-Item Env:TUGBOAT_IP "10.156.156.1"

# This addresses a regression in Docker 18.03.0-ce
# See https://github.com/docker/for-win/issues/1829
Set-Item Env:COMPOSE_CONVERT_WINDOWS_PATHS 1

docker-compose stop
docker-compose rm -f
docker-compose build
docker-compose up
