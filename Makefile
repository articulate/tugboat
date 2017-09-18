UNAME := $(shell uname)
DEVICE := $(shell netstat -r | grep ^default | tr ' ' '\n' | tail -n1)

start:
	docker-compose stop
	docker-compose rm -f
	docker-compose pull
	docker-compose build --pull
ifneq (, $(shell docker info | grep "provider=virtualbox"))
	@echo "---- YOU ARE RUNNING DOCKER TOOLBOX ----"
	TUGBOAT_IP=192.168.99.100 docker-compose up
else
	@echo "---- YOU ARE RUNNING DOCKER FOR MAC/WINDOWS/LINUX ----"
ifneq (, $(shell ifconfig | grep "192.168.65.1"))
	@echo "---- IP FOUND ----"
else
ifeq ($(UNAME), Linux)
	@echo "---- LINUX, ADDING IP ALIAS ----"
	sudo ifconfig $(DEVICE):tugboat 192.168.65.1 up
else
	@echo "---- MAC/WINDOWS, ADDING IP ALIAS ----"
	sudo ifconfig en0 alias 192.168.65.1 255.255.255.0
endif
endif
	TUGBOAT_IP=192.168.65.1 docker-compose up
endif

stop:
	docker-compose stop
ifeq ($(UNAME), Linux)
	sudo ifconfig $(DEVICE):tugboat 192.168.65.1 down
else
	sudo ifconfig en0 -alias 192.168.65.1
endif
