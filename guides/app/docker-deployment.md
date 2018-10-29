# Docker deployment

## Setup

### Prerequisites

The application has been setup for a [Distillery](distillery.md) release.

### Setup Docker Deployment

1. Configure Dockerfile `./Dockerfile`
2. Configure Heroku `./heroku.yml`, `app.json`

## Deploy to staging

    make -f deploy/staging/Makefile

For more information see: [Container Registry & Runtime \(Docker Deploys\)](https://devcenter.heroku.com/articles/container-registry-and-runtime)

## How to reproduce deployment environment locally

    make -f deploy/local/Makefile build
    make -f deploy/local/Makefile run
    make -f deploy/local/Makefile stop

For more information see: [Local Development with Docker Compose](https://devcenter.heroku.com/articles/local-development-with-docker-compose)

## References

The Distillery/Docker setup above is based on: [Building and configuring a Phoenix app with Umbrella for releasing with Docker](https://cultivatehq.com/posts/elixir-distillery-umbrella-docker/).
