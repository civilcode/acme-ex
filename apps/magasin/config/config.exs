# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :magasin, ecto_repos: [Magasin.Repo]

import_config "#{Mix.env}.exs"
