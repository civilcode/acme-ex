# Configuration

WEB_APP := magasin_web

# Targets

build: stop ensure_port_available do_build start setup

ensure_port_available:
	echo "Please ensure no Docker containers are running with the same ports as this docker-compose.yml file:"
	docker ps
	read -p "Press any key to continue..."

do_build:
	docker-compose build --force-rm --no-cache

reset_sync: stop clean start setup

clean:
	docker-compose rm -v -f
	docker-sync clean

setup:
	docker-compose exec application mix deps.get
	docker-compose exec application sh -c 'cd /app/apps/$(WEB_APP)/assets/ && npm install'
	# TEST
	docker-compose exec -e MIX_ENV=test application mix ecto.create
	docker-compose exec -e MIX_ENV=test application mix event_store.init
	docker-compose exec -e MIX_ENV=test application mix ecto.migrate
	# DEV
	docker-compose exec application mix ecto.create
	docker-compose exec application mix event_store.init
	docker-compose exec application mix ecto.migrate
	docker-compose exec application mix project.setup

docs:
	docker-compose exec application mix docs
	docker-compose exec application cp GLOSSARY.md apps/$(WEB_APP)/priv/static/
	docker-compose exec application cp -R doc apps/$(WEB_APP)/priv/static/

.PHONY: config
config:
	cp config/dev.secret.exs.sample config/dev.secret.exs
	cp config/test.secret.exs.sample config/test.secret.exs
	cp env.sample .env

	echo "Please configure the 'secret' configuration files in ./config directory."

start:
	docker-sync start
	docker-compose up --detach

stop:
	docker-compose stop
	docker-sync stop

restart: stop start

.PHONY: observer
observer:
	docker-compose exec -e DISPLAY=host.docker.internal:0 erlang erl -sname observer -hidden -setcookie secret -run observer

console:
	docker-compose exec application iex --name vm@application --cookie secret -S mix phx.server

generate_release:
	bin/generate_release

demo_data.dump:
	docker-compose exec application mix demo_data.dump

demo_data.load:
	docker-compose exec application mix demo_data.dump
