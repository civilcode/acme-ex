# Docker deployment

## Setup Distillery

* [ ] Install Distillery
* [ ] Run `mix release.init` and commit the `rel` folder
* [ ] Add config files for staging \(`config/staging.exs`\)
* [ ] Setup Distillery with staging in `rel/config.exs`
* [ ] Setup `Magasin.Repo` to get the `DATABASE_URL` environment variable \(`apps/magasin/lib/magasin/repo.ex`\)
* [ ] Setup a `package.json` in the `assets` folder by running `npm install`
* [ ] Setup `MagasinWeb.Endpoint` for production

  \`\`\`

  config :magasin\_web, MagasinWeb.Endpoint,

  http: \[port: {:system, "PORT"}\],

  url: \[host: "localhost", port: {:system, "PORT"}\], \# This is critical for ensuring web-sockets properly authorize.

  cache\_static\_manifest: "priv/static/cache\_manifest.json",

  server: true,

  root: ".",

  version: Application.spec\(:magasin\_web, :vsn\)

\`\`\`

* [ ] Setup `prod.exs` to not import a `prod.secrets.exs`

## Setup Docker Deployment

* [ ] Copy Dockerfiles \(`./Dockerfile`\)

## Setup Heroku

* [ ] Copy Heroku files \(`./heroku.yml`, `app.json`\)

The Distillery/Docker setup above is based on: [Building and configuring a Phoenix app with Umbrella for releasing with Docker](https://cultivatehq.com/posts/elixir-distillery-umbrella-docker/).

## Deploy to staging

```text
heroku container:login
heroku container:push web -r staging
heroku container:release web -r staging    
```

For more information see: [Container Registry & Runtime \(Docker Deploys\)](https://devcenter.heroku.com/articles/container-registry-and-runtime)

## How to reproduce deployment environment locally

```text
# build from the production Dockerfile
bin/heroku.docker.build

# run the Docker image
bin/heroku.docker.start

# stop the Docker container
bin/heroku.docker.stop    
```

For more information see: [Local Development with Docker Compose](https://devcenter.heroku.com/articles/local-development-with-docker-compose)

