use Mix.Config


config :magasin, Magasin.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "magasin_test",
  hostname: "db",
  username: "postgres",
  pool: Ecto.Adapters.SQL.Sandbox
