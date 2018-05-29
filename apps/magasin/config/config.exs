# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :magasin, ecto_repos: [Magasin.Repo]

config :magasin, Magasin.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "magasin_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

import_config "#{Mix.env}.exs"
