import Config

###############################################################################
# MAGASIN DATA
###############################################################################

config :magasin_data, MagasinData.Repo,
  url: System.get_env("DATABASE_URL"),
  ssl: true,
  queue_interval: 100,
  queue_target: 2000,
  pool_size: System.get_env("DATABASE_POOL_SIZE") |> String.to_integer()

###############################################################################
# MAGASIN WEB
###############################################################################

config :magasin_web, MagasinWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json",
  # Enable SSL on Heroku
  # force_ssl: [rewrite_on: [:x_forwarded_proto]],
  root: ".",
  url: [host: "localhost", port: System.get_env("PORT")],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  version: Application.spec(:magasin_web, :vsn)

config :phoenix, :serve_endpoints, true

###############################################################################
# MASTER PROXY
###############################################################################

config :master_proxy, http: [port: String.to_integer(System.get_env("PORT"))]

config :eventstore, EventStore.Storage,
  serializer: EventStore.TermSerializer,
  ssl: true,
  url: System.get_env("DATABASE_URL"),
  pool_size: 2,
  pool_overflow: 5
