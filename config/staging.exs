use Mix.Config

###############################################################################
# MAGASIN
###############################################################################

config :magasin, Magasin.Repo, ssl: true

###############################################################################
# MAGASIN WEB
###############################################################################

config :magasin_web, MagasinWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json",
  # Enable SSL on Heroku
  # force_ssl: [rewrite_on: [:x_forwarded_proto]],
  root: ".",
  version: Application.spec(:magasin_web, :vsn)
