# Magasin - CivilCode's Reference Application and Guides

[New Module](https://github.com/civilcode/magasin/issues/new?template=module.md) |
[New Ability](https://github.com/civilcode/magasin/issues/new?template=ability.md) |
[New Task](https://github.com/civilcode/magasin/issues/new?template=task.md) |
[New Bug](https://github.com/civilcode/magasin/issues/new?template=bug.md)

## About Magasin

Magasin is CivilCode's reference application and [development guides](./guides). It demonstrates
how we develop Elixir and Phoenix applications using an opinionated approach influenced by
[Domain-Driven Design](https://en.wikipedia.org/wiki/Domain-driven_design).

The application implements a basic ordering system.

## Technical Overview

* implemented as an Elixir umbrella application
* with a Phoenix HTML interface
* deployed on [Heroku](https://magasin-platform.herokuapp.com) with [Docker](https://www.docker.com)
* persists data in [PostgreSQL](https://www.postgresql.org) RDBMS
* an open source application with the source code hosted on [GitHub](https://github.com/civilcode/magasin)

## Development Setup

For a Docker-based development environment run the following setup scripts and follow the instructions:

    git clone https://github.com/civilcode/magasin-platform
    cd magasin-platform    
    ./bin/setup
    ./bin/docker.setup

To run the server:

    docker-compose exec application mix phx.server

Visit http://localhost:4000.

To start and shutdown Docker containers:

    docker-compose up -d
    docker-compose stop

## Running Tests

    docker-compose exec -e MIX_ENV=test application mix ecto.create
    docker-compose exec application mix test

## Helpful Commands

    docker-compose build
    docker-compose up -d
    docker-compose exec application mix ecto.create
    docker-compose exec application mix test
    docker-compose exec application mix test.watch
    docker-compose exec application mix ecto.rollback
    docker-compose exec application bash

## Deployment to staging

    heroku container:push web -r staging
    heroku container:release web -r staging    

For more information see: [Container Registry & Runtime (Docker Deploys)](https://devcenter.heroku.com/articles/container-registry-and-runtime)

### How to reproduce deployment environment locally
    # build from the production Dockerfile
    bin/heroku.docker.build

    # run the Docker image
    bin/heroku.docker.start

    # stop the Docker container
    bin/heroku.docker.stop    

For more information see: [Local Development with Docker Compose](https://devcenter.heroku.com/articles/local-development-with-docker-compose)

## About CivilCode Inc

[CivilCode Inc.](http://www.civilcode.io) develops tailored business applications in [Elixir](http://elixir-lang.org/) and [Phoenix](http://www.phoenixframework.org/)
in Montreal, Canada.
