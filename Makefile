start:
	docker-compose stop
	docker-compose rm -f
	docker-compose build
ifneq (, $(shell docker info | grep "provider=virtualbox"))
	@echo "---- YOU ARE RUNNING DOCKER TOOLBOX ----"
	TUGBOAT_IP=192.168.99.100 docker-compose up
else
	@echo "---- YOU ARE RUNNING DOCKER FOR MAC/WINDOWS ----"
	TUGBOAT_IP=192.168.65.1 docker-compose up
endif

stop:
	docker-compose stop
