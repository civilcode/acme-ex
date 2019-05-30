use Mix.Config

###############################################################################
# MAGASIN DATA
###############################################################################

config :magasin_core,
  ecto_repos: [MagasinData.Repo],
  release: [tag: System.get_env("RELEASE_TAG")]

config :magasin_data, MagasinData.Repo,
  adapter: Ecto.Adapters.Postgres,
  migration_primary_key: [name: :id, type: :binary_id]

###############################################################################
# MAGASIN WEB
###############################################################################

config :magasin_web,
  generators: [context_app: :magasin]

config :magasin_web, MagasinWeb.Endpoint,
  http: [port: 4010],
  pubsub: [name: MagasinWeb.PubSub, adapter: Phoenix.PubSub.PG2],
  render_errors: [view: MagasinWeb.ErrorView, accepts: ~w(html json)],
  secret_key_base: "t+rnxLm4FP2zzACQCy/v65vJ0U9oL5OqHBtcKqKMLhQvHc1sLw0D3S292UgItkIV",
  url: [host: "localhost", port: 4000]

config :phoenix, :json_library, Jason

config :phoenix, :template_engines,
  slim: PhoenixSlime.Engine,
  slime: PhoenixSlime.Engine

import_config "#{Mix.env()}.exs"

###############################################################################
# MASTER PROXY
###############################################################################

config :master_proxy, http: [port: 4000]
