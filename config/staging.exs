use Mix.Config

###############################################################################
# MAGASIN
###############################################################################

config :magasin_web, MagasinWeb.Endpoint,
  # This is critical for ensuring web-sockets properly authorize.
  url: [host: "localhost", port: 4010],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true,
  root: ".",
  version: Application.spec(:magasin_web, :vsn)

config :magasin, Magasin.Repo,
  adapter: Ecto.Adapters.Postgres,
  ssl: true
