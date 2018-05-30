use Mix.Config

config :magasin, Magasin.Repo,
  adapter: Ecto.Adapters.Postgres,
  ssl: true
