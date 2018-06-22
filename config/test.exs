use Mix.Config

###############################################################################
# MAGASIN
###############################################################################

config :magasin, Magasin.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "magasin_test",
  hostname: "db",
  username: "postgres",
  pool: Ecto.Adapters.SQL.Sandbox

###############################################################################
# MAGASIN WEB
###############################################################################

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :magasin_web, MagasinWeb.Endpoint,
  http: [port: 4001],
  server: false

import_config "test.secret.exs"
