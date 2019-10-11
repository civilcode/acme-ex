import Config

# Note: Only runtime configuration (i.e. not static) should be added to this file.

###############################################################################
# MAGASIN WEB
###############################################################################

config :magasin_web, MagasinWeb.Endpoint,
  url: [host: "localhost", port: System.get_env("PORT")],
  secret_key_base: System.get_env("SECRET_KEY_BASE")

###############################################################################
# MASTER PROXY
###############################################################################

config :master_proxy, http: [port: String.to_integer(System.get_env("PORT"))]

config :eventstore, EventStore.Storage,
  serializer: EventStore.TermSerializer,
  url: System.get_env("DATABASE_URL"),
  pool_size: 2,
  pool_overflow: 5
