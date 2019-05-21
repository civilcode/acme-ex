# Configuration - Local

IMAGE_NAME := acme-platform-local
BINARY := acme_platform

# Configuration - Heroku

DATABASE_URL := $(shell heroku config:get DATABASE_URL -r staging)
SECRET_KEY_BASE := $(shell heroku config:get SECRET_KEY_BASE -r staging)

# Targets

.PHONY: deploy
deploy: build run

build:
	docker build --no-cache --build-arg MIX_ENV=staging -t $(IMAGE_NAME) -f Dockerfile .

run:
	docker run -i --name $(IMAGE_NAME) -t --rm -p 4000:4000 \
		-e DATABASE_POOL_SIZE=5 \
		-e DATABASE_URL=$(DATABASE_URL) \
		-e SECRET_KEY_BASE=$(SECRET_KEY_BASE) \
		$(IMAGE_NAME) /app/bin/$(BINARY) foreground

stop:
	docker stop $(IMAGE_NAME)
