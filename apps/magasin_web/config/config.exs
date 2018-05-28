# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :magasin_web,
  generators: [context_app: :magasin]

# Configures the endpoint
config :magasin_web, MagasinWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "t+rnxLm4FP2zzACQCy/v65vJ0U9oL5OqHBtcKqKMLhQvHc1sLw0D3S292UgItkIV",
  render_errors: [view: MagasinWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MagasinWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
