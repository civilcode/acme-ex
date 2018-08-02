# Platform Setup Guide

This guide specifies the steps required to setup a new application.

## GitHub

1. Create the GitHub repository `{client-name}-platform`
2. [Generate labels](github.md)

## Elixir Application

1. Clone the reference app `git clone https://github.com/civilcode/magasin-platform`
2. Run `./bin/project.new`
3. Add CSS template to the web application
4. Configure Basic Authentication on the staging environment

## Services

* [Setup S3](s3.md), if required
* Configure [CircleCI](http://circleci.com)
* Configure [Coveralls](coveralls.md)

## Heroku Deployment with Docker

* Setup `staging` application
* Configure `staging` application with [Review Apps](https://devcenter.heroku.com/articles/github-integration-review-apps)
* Setup `production` application
* Enable backups on PostgreSQL

## Remote Pairing

* [Setup Cloud9](https://github.com/civilcode/cloud9-bootstrap)
