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

    heroku container:release web -a magasin-platform
    heroku container:push web -a magasin-platform

### How to reproduce deployment environment locally

    # retrieve the production DATABASE_URL
    db_url=$(heroku config:get DATABASE_URL -a magasin-platform)

    # build from the production Dockerfile and run
    docker build --no-cache --build-arg MIX_ENV=staging -t magasin/app -f Dockerfile .
    docker run -i --name magasin -t --rm -p 4000:4000 -e DATABASE_URL=$db_url magasin/app /app/bin/magasin foreground

    # stop and remove
    docker stop magasin
    docker container rm magasin

    # connect to a running container
    docker exec -it magasin bash

## About CivilCode Inc

[CivilCode Inc.](http://www.civilcode.io) develops tailored business applications in [Elixir](http://elixir-lang.org/) and [Phoenix](http://www.phoenixframework.org/)
in Montreal, Canada.
