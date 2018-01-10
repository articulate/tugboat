set TUGBOAT_IP=192.168.65.2

docker-compose stop
docker-compose rm -f
docker-compose pull
docker-compose build --pull
docker-compose up
