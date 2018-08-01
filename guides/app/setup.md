# Setup Guide

This guide covers everything that needs to be setup for a new application.

## GitHub

* Create repository `{client-name}-platform`
* [Generate labels](https://github.com/civilcode/magasin-platform/tree/3c0ec7def06ed304b6b6069edd846d6d3837b5f3/.github/SETUP.md)

## Elixir application
* Clone the reference app `git clone https://github.com/civilcode/magasin-platform`
* Run `./bin/project.init`
* Add CSS template
* Add \[GitHub Issue Templates\]\(\(../../.github/SETUP.md\)\)
* Add Basic Authentication to staging environment

## Services

* [Setup S3](s3.md) \(if required\)
* Configure [CircleCI](http://circleci.com)
* Configure [Coveralls](setup-coveralls.md)
* [Setup Docker](https://github.com/civilcode/magasin-platform/tree/3c0ec7def06ed304b6b6069edd846d6d3837b5f3/guides/app/docker.md) \(if required\)

## Heroku Deployment with Docker

* Setup `production` application
* Setup `staging` application
* Configure `staging` application with [Review Apps](https://devcenter.heroku.com/articles/github-integration-review-apps)
* Enable backups on PostgreSQL

## Remote Pairing

* [Setup Cloud9](https://github.com/civilcode/cloud9-bootstrap)
