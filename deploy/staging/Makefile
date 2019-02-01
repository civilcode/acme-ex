# Configuration

APP := acme-platform
BINARY := acme_platform

# Targets

.PHONY: deploy
deploy: push release reset

push:
	git fetch --all --tags
	git checkout tags/$(RELEASE_TAG)
	heroku container:login
	heroku container:push web -r staging --arg RELEASE_TAG=$(RELEASE_TAG)

release:
	heroku container:release web -r staging

reset:
	heroku pg:reset --confirm $(APP)-staging -r staging
	heroku run /app/bin/$(BINARY) migrate -r staging
