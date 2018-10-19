# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# By default, the umbrella project as well as each child
# application will require this configuration file, ensuring
# they all use the same configuration. While one could
# configure all applications here, we prefer to delegate
# back to each application for organization purposes.
# General application configuration

###############################################################################
# MAGASIN
###############################################################################

config :magasin, ecto_repos: [Magasin.Repo]

###############################################################################
# MAGASIN WEB
###############################################################################

config :magasin_web,
  generators: [context_app: :magasin]

# Configures the endpoint
config :magasin_web, MagasinWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "t+rnxLm4FP2zzACQCy/v65vJ0U9oL5OqHBtcKqKMLhQvHc1sLw0D3S292UgItkIV",
  render_errors: [view: MagasinWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MagasinWeb.PubSub, adapter: Phoenix.PubSub.PG2]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :phoenix, :template_engines,
  slim: PhoenixSlime.Engine,
  slime: PhoenixSlime.Engine

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
