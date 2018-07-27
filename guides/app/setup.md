# Setup Guide

This guide covers everything that needs to be setup for a new application.

## GitHub

* [ ] Create repository `{client-name}-platform`
* [ ] [Generate labels](https://github.com/civilcode/magasin-platform/tree/3c0ec7def06ed304b6b6069edd846d6d3837b5f3/.github/SETUP.md)

## Elixir application

* [ ] Generate Elixir application `mix new {client-name}-platform`, e.g. `mix new civilcode_platform`
* [ ] Generate "library" application, e.g. `mix new {client-name}_ex`
* [ ] Configure "library" application
  * [ ] Dialyzer
  * [ ] Credo
* [ ] Configure `mix project.check`
* [ ] Generate "command" application configure with Ecto
* [ ] Generate Phoenix application
* [ ] Remove all generated comments
* [ ] Add CSS template
* [ ] Add \[GitHub Issue Templates\]\(\(../../.github/ISSUE\_TEMPLATES.md\)\)
* [ ] Update README.md based on the [reference application](https://github.com/civilcode/magasin-platform/tree/3c0ec7def06ed304b6b6069edd846d6d3837b5f3/README.md)
* [ ] Add [Glossary](https://github.com/civilcode/magasin-platform/tree/3c0ec7def06ed304b6b6069edd846d6d3837b5f3/GLOSSARY.md)
* [ ] [Centralize configuration](https://github.com/civilcode/magasin-platform/tree/3c0ec7def06ed304b6b6069edd846d6d3837b5f3/config/README.md)
* [ ] Create staging environment configuration
* [ ] Add Basic Authentication to staging environment

## Services

* [ ] [Setup S3](s3.md) \(if required\)
* [ ] Configure [CircleCI](http://circleci.com)
* [ ] Configure [Coveralls](https://coveralls.io)
* [ ] [Setup Docker](https://github.com/civilcode/magasin-platform/tree/3c0ec7def06ed304b6b6069edd846d6d3837b5f3/guides/app/docker.md) \(if required\)

## Heroku Deployment with Docker

* [ ] Setup `production` application
* [ ] Setup `staging` application
* [ ] Configure `staging` application with [Review Apps](https://devcenter.heroku.com/articles/github-integration-review-apps)
* [ ] Enable backups on PostgreSQL

## Remote Pairing

* [ ] [Setup Cloud9](https://github.com/civilcode/cloud9-bootstrap)

