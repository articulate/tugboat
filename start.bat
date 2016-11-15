docker-machine env > docker-init.cmd
cmd.exe /c docker-init.cmd
del docker-init.cmd
docker-compose stop
docker-compose rm -f
docker-compose build
docker-compose up