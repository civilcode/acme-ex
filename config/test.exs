import Config

###############################################################################
# MAGASIN
###############################################################################

config :magasin_core,
  release: [tag: "Test"]

###############################################################################
# MAGASIN WEB
###############################################################################

config :magasin_web, MagasinWeb.Endpoint, server: false

config :logger, level: :warn

import_config "test.secret.exs"
