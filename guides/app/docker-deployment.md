# Docker deployment

## Setup

### Prerequisites

The application has been setup for a [Distillery](distillery.md) release.

### Setup Docker Deployment

1. Configure Dockerfile `./Dockerfile`
2. Configure Heroku `./heroku.yml`, `app.json`

## Deploy to staging

    heroku container:login
    heroku container:push web -r staging
    heroku container:release web -r staging    

For more information see: [Container Registry & Runtime \(Docker Deploys\)](https://devcenter.heroku.com/articles/container-registry-and-runtime)

## How to reproduce deployment environment locally

    # build from the production Dockerfile
    bin/heroku.docker.build

    # run the Docker image
    bin/heroku.docker.start

    # stop the Docker container
    bin/heroku.docker.stop    

For more information see: [Local Development with Docker Compose](https://devcenter.heroku.com/articles/local-development-with-docker-compose)

## References

The Distillery/Docker setup above is based on: [Building and configuring a Phoenix app with Umbrella for releasing with Docker](https://cultivatehq.com/posts/elixir-distillery-umbrella-docker/).
