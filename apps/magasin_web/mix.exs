defmodule MagasinWeb.MixProject do
  use Mix.Project

  def project do
    [
      app: :magasin_web,
      version: "0.0.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls]
    ]
  end

  def application do
    [
      mod: {MagasinWeb.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:phoenix, "~> 1.4"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_html, "~> 2.13"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_slime, "~> 0.12.0"},
      {:gettext, "~> 0.11"},
      {:magasin, in_umbrella: true},
      {:jason, "~> 1.0"},
      {:sobelow, "~> 0.7.1", only: [:dev, :test]},
      {:plug_cowboy, "~> 2.0"}
    ]
  end

  defp aliases do
    []
  end
end
