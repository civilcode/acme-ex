use Mix.Config

###############################################################################
# MASTER PROXY
###############################################################################

config :master_proxy, http: [port: System.get_env("PORT")]

###############################################################################
# MAGASIN WEB
###############################################################################

config :magasin_web, MagasinWeb.Endpoint,
  http: [port: System.get_env("PORT")],
  secret_key_base: System.get_env("SECRET_KEY_BASE")
