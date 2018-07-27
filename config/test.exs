use Mix.Config

###############################################################################
# MASTER PROXY
###############################################################################

config :master_proxy, http: [port: 4001]

###############################################################################
# MAGASIN WEB
###############################################################################

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :magasin_web, MagasinWeb.Endpoint,
  http: [port: 4011],
  server: false

import_config "test.secret.exs"
