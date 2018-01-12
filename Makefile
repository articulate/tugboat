UNAME := $(shell uname)

ifeq ($(UNAME), Linux)
DEVICE := $(shell netstat -rn -A inet | grep ^0.0.0.0 | tr ' ' '\n' | tail -n1)
else
DEVICE := $(shell netstat -rn -f inet | grep -v "link\#" | grep ^default | tr ' ' '\n' | tail -n1)
endif

start:
ifneq (, $(shell ifconfig | grep "192.168.65.1"))
ifeq ($(UNAME), Linux)
	@echo "---- LINUX, CLEANING OLD IP ALIAS ----"
	sudo ifconfig $(DEVICE):tugboat 192.168.65.1 down || true
else
	@echo "---- MAC, CLEANING OLD IP ALIAS ----"
	sudo ifconfig $(DEVICE) -alias 192.168.65.1 || true
endif
endif
ifneq (, $(shell ifconfig | grep "192.168.65.2"))
ifeq ($(UNAME), Linux)
	@echo "---- LINUX, CLEANING OLD IP ALIAS ----"
	sudo ifconfig $(DEVICE):tugboat 192.168.65.2 down || true
else
	@echo "---- MAC, CLEANING OLD IP ALIAS ----"
	sudo ifconfig $(DEVICE) -alias 192.168.65.2 || true
endif
endif
	docker-compose stop
	docker-compose rm -f
	docker-compose pull
	docker-compose build --pull
ifneq (, $(shell docker info | grep "provider=virtualbox"))
	@echo "---- YOU ARE RUNNING DOCKER TOOLBOX ----"
	TUGBOAT_IP=192.168.99.100 docker-compose up
else
	@echo "---- YOU ARE RUNNING DOCKER FOR MAC/LINUX ----"
ifneq (, $(shell ifconfig | grep "10.156.156.1"))
	@echo "---- IP FOUND ----"
else
ifeq ($(UNAME), Linux)
	@echo "---- LINUX, ADDING IP ALIAS ----"
	sudo ifconfig $(DEVICE):tugboat 10.156.156.1 up
else
	@echo "---- MAC, ADDING IP ALIAS ----"
	sudo ifconfig $(DEVICE) alias 10.156.156.1 255.255.255.0
endif
endif
	TUGBOAT_IP=10.156.156.1 docker-compose up
endif

stop:
	docker-compose stop
	docker-compose rm -f
ifeq ($(UNAME), Linux)
	sudo ifconfig $(DEVICE):tugboat 10.156.156.1 down || true
else
	sudo ifconfig $(DEVICE) -alias 10.156.156.1 || true
endif
