# Heroku

## Enable SSL

* Heroku provide SSL out of the box via [Let's Encrypt](https://devcenter.heroku.com/articles/automated-certificate-management).
* As long as a Phoenix Endpoint redirects with a Secure HTTP protocol there is nothing else that needs to be done.

```elixir
config :magasin_web, MagasinWeb.Endpoint,
    # Enable SSL on Heroku
    force_ssl: [rewrite_on: [:x_forwarded_proto]],
```

## Remote Observing

This application is setup to remotely observe the application on a Heroku Dyno:

1. make -f deploy/staging/Makefile heroku.port.forward
2. make -f deploy/staging/Makefile ERLANG_COOKIE="{cookie-in-mix-file}"

References:

- [Using SSH Tunnelling with Docker on Heroku](https://devcenter.heroku.com/articles/exec#using-with-docker)
- [Tracing and observing your remote node](http://blog.plataformatec.com.br/2016/05/tracing-and-observing-your-remote-node/)
- [Pull Request](https://github.com/civilcode/acme-platform/pull/221)

## Upgrade Database

See: https://devcenter.heroku.com/articles/upgrading-heroku-postgres-databases

For hobby databases (verify `HEROKU_POSTGRESQL_PINK`):

     heroku addons:create heroku-postgresql:hobby-dev -a acme-platform-staging
     heroku maintenance:on -a acme-platform-staging
     heroku pg:copy DATABASE_URL HEROKU_POSTGRESQL_PINK -a acme-platform-staging
     heroku pg:promote HEROKU_POSTGRESQL_PINK -a acme-platform-staging
     heroku maintenance:off -a acme-platform-staging
     heroku addons -a acme-platform-staging
     heroku addons:destroy HEROKU_POSTGRESQL_LAVENDER -a acme-platform-staging
