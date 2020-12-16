# Acme - CivilCode's Reference Application and Guides [![Coverage Status](https://coveralls.io/repos/github/civilcode/acme-platform/badge.svg?branch=master)](https://coveralls.io/github/civilcode/acme-platform?branch=master)

## About Magasin

Magasin is CivilCode's reference application and [development guides](./guides). It demonstrates
how we develop Elixir and Phoenix applications using an opinionated approach influenced by
[Domain-Driven Design](https://en.wikipedia.org/wiki/Domain-driven_design).

The application implements a basic ordering system.

## Technical Overview

* implemented as an Elixir umbrella application
* with a Phoenix HTML interface
* deployed on [Heroku](https://acme-platform.herokuapp.com) with [Docker](https://www.docker.com)
* persists data in [PostgreSQL](https://www.postgresql.org) RDBMS
* an open source application with the source code hosted on [GitHub](https://github.com/civilcode/acme-platform)

## Development Setup

Before following the instructions below, ensure your development environment meets the prerequisites
outlined here:

    https://github.com/civilcode/playbook/blob/master/guides/ops/developer_setup.md

For a Docker-based development environment run the following setup scripts and follow
the instructions:

    git clone https://github.com/civilcode/acme-platform
    cd acme-platform
    make app.config
    make build

To run the server:

    make app.run

To view the application with your browser visit:

    http://localhost:4000

To start and shutdown Docker containers:

    make start
    make stop

## Deployment
### Managing Releases

Before deploying to staging or production, you must create a release.

    make release.create

### Deployment to staging

To deploy to staging:

    make -f deploy/staging/Makefile RELEASE_TAG=<git_tag>


### Fake, Seed, and Demo Data

- Fake data: fake data simulating production data -- only for demonstration purposes
- Seed data: data necessary to bootstrap a working production database
- Demo data: fake data + seed data that has been saved in a SQL dump so we can load it easily

Most of the time, the demo data should include all of the seed data. However, this may not be the case when developing a feature (the developer defines seed data first, and dumps it later).

Procedure for updating demo data:
1. make changes to seeds (if necessary) in `MagasinData.Tasks.Seed`
2. `dea mix project.setup` to load the existing demo data and create your seeds
3. make the changes you want to the demo database (use iex, web interface, [DBeaver](https://dbeaver.io/) client or similar)
4. run `make demo.dump`
5. changes should be reflected in `apps/magasin_data/priv/demo.sql`

## Guides

For more information on working with Docker for local development, deployment and other
application development guides visit:

    https://civilcode.gitbook.io/developer-guides/

## About the CivilCode Collective

The [CivilCode Collective](http://www.civilcode.io), a group of freelance developers, build tailored business applications in [Elixir](http://elixir-lang.org/) and [Phoenix](http://www.phoenixframework.org/)
in Montreal, Canada.
