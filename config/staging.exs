use Mix.Config

###############################################################################
# MAGASIN DATA
###############################################################################

config :magasin_data, MagasinData.Repo, ssl: true, queue_interval: 100, queue_target: 2000

###############################################################################
# MAGASIN WEB
###############################################################################

config :magasin_web, MagasinWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json",
  # Enable SSL on Heroku
  # force_ssl: [rewrite_on: [:x_forwarded_proto]],
  root: ".",
  version: Application.spec(:magasin_web, :vsn)

config :phoenix, :serve_endpoints, true
