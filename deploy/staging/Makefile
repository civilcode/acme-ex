# Configuration

HEROKU_APP := acme-platform-staging
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
	heroku pg:reset --confirm $(HEROKU_APP) -a $(HEROKU_APP)
	heroku run /app/bin/$(BINARY) load_demo_data -a $(HEROKU_APP)
	heroku run /app/bin/$(BINARY) seed -a $(HEROKU_APP)

bash:
	heroku run bash -r staging
