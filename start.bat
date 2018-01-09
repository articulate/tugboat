set TUGBOAT_IP=192.168.64.1

docker-compose stop
docker-compose rm -f
docker-compose build
docker-compose up
