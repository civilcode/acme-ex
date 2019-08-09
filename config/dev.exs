import Config

###############################################################################
# MAGASIN
###############################################################################

config :magasin_core,
  release: [tag: "Development"]

###############################################################################
# MAGASIN WEB
###############################################################################

config :magasin_web, MagasinWeb.Endpoint,
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
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
