bash:
	@docker compose run --rm --service-ports app bash
	docker compose stop

down:
	@docker compose down

clean:
	@docker compose down --rmi local --remove-orphans

setup:
	@docker compose run --rm app bash -c "./bin/setup --skip-server"
	docker compose stop

tests:
	@docker compose run --rm app bash -c "bin/rails test:all"
	docker compose stop

up:
	@docker compose up
	docker compose stop
