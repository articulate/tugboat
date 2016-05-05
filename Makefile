start:
ifneq (, $(shell which pinata))
	@echo "---- YOU MAY BE RUNNING BETA DOCKER ----"
	@echo 'Your results may vary.'
	@echo "-------------------------------------"
	@echo ""
	@echo "Sleeping 10 seconds...."
	@sleep 10
else ifeq ("${DOCKER_MACHINE_NAME}", "")
	@echo "---- YOUR DOCKER MACHINE IS NOT INITIALIZED ----"
	@echo 'Please run "eval $$(docker-machine env default)"'
	@echo "------------------------------------------------"
	@exit 1
else ifneq ($(shell docker-machine ip ${DOCKER_MACHINE_NAME}),192.168.99.100)
	@echo "---- YOUR DOCKER IP IS WRONG ----"
	@echo "Your docker IP should be 192.168.99.100, but it is $(shell docker-machine ip ${DOCKER_MACHINE_NAME})"
	@echo "See: https://github.com/articulate/tugboat/blob/master/README.md#tugboat-says-my-ip-doesnt-match-19216899100"
	@echo "---------------------------------"
	@exit 1
endif
	docker-compose stop
	docker-compose rm -f
	docker-compose build
	docker-compose up

stop:
	docker-compose stop
