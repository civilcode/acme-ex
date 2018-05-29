use Mix.Config

config :magasin, Magasin.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: "${DATABASE_URL}"
