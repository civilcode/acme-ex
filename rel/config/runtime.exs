use Mix.Config

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
