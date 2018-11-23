.PHONY: deploy
deploy: push release reset

push:
	heroku container:login
	heroku container:push web -r staging

release:
	heroku container:release web -r staging

reset:
	heroku pg:reset --confirm acme-platform-staging -r staging
	heroku run /app/bin/acme_platform migrate -r staging
