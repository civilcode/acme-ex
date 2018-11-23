DATABASE_URL := $(shell heroku config:get DATABASE_URL -r staging)

.PHONY: deploy
deploy: build run

build:
	docker build --no-cache --build-arg MIX_ENV=staging -t acme-platform -f Dockerfile .

run:
	docker run -i --name acme-platform -t --rm -p 4000:4000 \
		-e DATABASE_POOL_SIZE=5 \
		-e DATABASE_URL=$(DATABASE_URL) \
		-e SECRET_KEY_BASE="76kdAGeJAyvTbuKTqcWRzN5v1WR/Th7rDOPnlHCxZwc4KRxg5qe3ooDiZirHf/WI" \
		acme-platform /app/bin/acme_platform foreground

stop:
	docker stop acme-platform
