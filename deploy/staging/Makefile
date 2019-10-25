# Configuration

HEROKU_APP := acme-platform-staging
BINARY := acme_platform

# Targets

.PHONY: deploy
deploy: deploy.push deploy.release db.reset

deploy.push:
	git fetch --all --tags
	git checkout tags/$(RELEASE_TAG)
	heroku container:login
	heroku container:push web -r staging --arg RELEASE_TAG=$(RELEASE_TAG)

deploy.release:
	heroku container:release web -r staging

db.reset:
	heroku pg:reset --confirm $(HEROKU_APP) -a $(HEROKU_APP)
	heroku run /app/bin/$(BINARY) load_demo -a $(HEROKU_APP)
	heroku run /app/bin/$(BINARY) seed -a $(HEROKU_APP)

heroku.bash:
	heroku ps:exec -a $(HEROKU_APP)

# See guides/app/heroku.md for remote observing
heroku.port.forward:
	heroku ps:forward 4369,9001 -a $(HEROKU_APP)

heroku.observe:
	epmd -names
	iex --name console@127.0.0.1 --cookie '$(ERLANG_COOKIE)' -e ':observer.start'
