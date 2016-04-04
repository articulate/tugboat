start:
ifeq ("${DOCKER_MACHINE_NAME}", "")
	@echo "---- YOUR DOCKER MACHINE IS NOT INITIALIZED ----"
	@echo 'Please run "eval $$(docker-machine env default)"'
	@echo "------------------------------------------------"
else ifeq ($(shell docker-machine ip ${DOCKER_MACHINE_NAME}),192.168.99.100)
	docker-compose stop
	docker-compose rm -f
	docker-compose build
	docker-compose up
else ifeq
	@echo "---- YOUR DOCKER IP IS WRONG ----"
	@echo "Your docker IP should be 192.168.99.100, but it is $(shell docker-machine ip ${DOCKER_MACHINE_NAME})"
	@echo "---------------------------------"
endif

stop:
	docker-compose stop
