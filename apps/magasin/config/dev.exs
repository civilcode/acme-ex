use Mix.Config

config :magasin, Magasin.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: {:system, "DATABASE_URL" },
  ssl: true
