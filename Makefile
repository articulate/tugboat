start:
	docker-compose stop
	docker-compose rm -f
	docker-compose build
	docker-compose up

stop:
	docker-compose stop
