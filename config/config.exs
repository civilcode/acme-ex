use Mix.Config

###############################################################################
# MAGASIN
###############################################################################

config :magasin, ecto_repos: [Magasin.Repo]

###############################################################################
# MAGASIN WEB
###############################################################################

config :magasin_web,
  generators: [context_app: :magasin]

config :magasin_web, MagasinWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "t+rnxLm4FP2zzACQCy/v65vJ0U9oL5OqHBtcKqKMLhQvHc1sLw0D3S292UgItkIV",
  render_errors: [view: MagasinWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MagasinWeb.PubSub, adapter: Phoenix.PubSub.PG2]

config :phoenix, :json_library, Jason

config :phoenix, :template_engines,
  slim: PhoenixSlime.Engine,
  slime: PhoenixSlime.Engine

import_config "#{Mix.env()}.exs"
