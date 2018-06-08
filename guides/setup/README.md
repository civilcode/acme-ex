# Setup Guide

This guide covers everything that needs to be setup for an application.

## GitHub

- [ ] Create repository `{client-name}-platform`
- [ ] [Generate labels](../../.github/SETUP.md)

## Elixir application

- [ ] Generate Elixir application `mix new {client-name}-platform`, e.g. `mix new civilcode_platform`
- [ ] Generate "library" application, e.g. `mix new {client-name}_ex`
- [ ] Configure "library" application
  - [ ] Dialyzer
  - [ ] Credo
- [ ] Configure `mix project.check`
- [ ] Generate "command" application configure with Ecto
- [ ] Generate Phoenix application
- [ ] Remove all generated comments
- [ ] Add CSS template
- [ ] Add [GitHub Issue Templates]((../../.github/ISSUE_TEMPLATES.md))
- [ ] Update README.md based on the [reference application](../../README.md)
- [ ] Add [Glossary](../../GLOSSARY.md)
- [ ] [Centralize configuration](../../config)
- [ ] Create staging environment configuration
- [ ] Add Basic Authentication to staging environment

## Services

- [ ] [Setup S3](./s3.md) (if required)
- [ ] Configure [CircleCI](http://circleci.com)
- [ ] Configure [Coveralls](https://coveralls.io)
- [ ] [Setup Docker](./docker.md) (if required)

## Heroku Deployment with Docker

- [ ] Setup `production` application
- [ ] Setup `staging` application
- [ ] Configure `staging` application with [Review Apps](https://devcenter.heroku.com/articles/github-integration-review-apps)
- [ ] Enable backups on PostgreSQL

## Remote Pairing

- [ ] [Setup Cloud9](https://github.com/civilcode/cloud9-bootstrap)
