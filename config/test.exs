use Mix.Config

###############################################################################
# MAGASIN WEB
###############################################################################

config :magasin_web, MagasinWeb.Endpoint, server: false

import_config "test.secret.exs"
