use Mix.Config

###############################################################################
# MASTER PROXY
###############################################################################

config :master_proxy, http: [port: 4000]

###############################################################################
# MAGASIN WEB
###############################################################################

config :magasin_web, MagasinWeb.Endpoint,
  http: [port: 4010],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch-stdin",
      cd: Path.expand("../apps/magasin_web/assets", __DIR__)
    ]
  ]

config :magasin_web, MagasinWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/magasin_web/views/.*(ex)$},
      ~r{lib/magasin_web/templates/.*(eex|slim|slime)$}
    ]
  ]

config :phoenix, :plug_init_mode, :runtime

import_config "dev.secret.exs"
