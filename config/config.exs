import Config

# Ensure Custom Credo Check is reference for SourceLevel.io

CivilCredo

###############################################################################
# CivilBus
###############################################################################

config :civil_bus, impl: CivilBus.EventStore

###############################################################################
# MAGASIN CORE
###############################################################################

config :magasin_core,
  ecto_repos: [MagasinData.Repo],
  release: [tag: System.get_env("RELEASE_TAG")]

###############################################################################
# MAGASIN DATA
###############################################################################

config :magasin_data, MagasinData.Repo,
  # avoids conflict with EventStore schema_migrations
  # https://github.com/commanded/eventstore/issues/73
  migration_source: "ecto_schema_migrations",
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
