build:
	echo "Please ensure no Docker containers are running with the same ports as this docker-compose.yml file"
	read -p "Press any key to continue..."
	docker-compose build --force-rm --no-cache
	docker-compose up -d
	docker-compose exec application mix deps.get
	docker-compose exec application sh -c 'cd /app/apps/magasin_web/assets/ && npm install'
	docker-compose exec -e MIX_ENV=test application mix ecto.create
	docker-compose exec application mix project.setup

clean:
	docker-compose stop
	rm -rf deps
	rm -rf _build
	rm -rf apps/magasin_web/assets/node_modules
	rm -rf apps/magasin_web/priv/static
	docker-compose up -d
	docker-compose exec application mix deps.get

.PHONY: config
config:
	cp config/dev.secret.exs.sample config/dev.secret.exs
	cp config/test.secret.exs.sample config/test.secret.exs
	cp env.sample .env

	echo "Please configure the 'secret' configuration files in ./config directory."

setup:
	./bin/setup.config
	./bin/setup.docker

start:
	docker-compose up -d

stop:
	docker-compose stop
