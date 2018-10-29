clean:
	docker-compose stop
	rm -rf deps
	rm -rf _build
	rm -rf apps/magasin_web/assets/node_modules
	docker-compose up -d
	docker-compose exec application mix deps.get

setup:
	./bin/setup.config
	./bin/setup.docker

start:
	docker-compose up -d

stop:
	docker-compose stop
