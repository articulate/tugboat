REM FOR /f "tokens=*" %%i IN ('docker-machine env') DO @%%i
docker-compose stop
docker-compose rm -f
docker-compose build
docker-compose up
