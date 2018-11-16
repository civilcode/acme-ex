# Heroku

## Enable SSL

* Heroku provide SSL out of the box via [Let's Encrypt](https://devcenter.heroku.com/articles/automated-certificate-management).
* As long as a Phoenix Endpoint redirects with a Secure HTTP protocol there is nothing else that needs to be done.

```elixir
config :magasin_web, MagasinWeb.Endpoint,
    # Enable SSL on Heroku
    force_ssl: [rewrite_on: [:x_forwarded_proto]],
```
