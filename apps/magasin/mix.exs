defmodule Magasin.MixProject do
  use Mix.Project

  def project do
    [
      app: :magasin,
      version: "0.0.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      aliases: aliases(),
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Magasin.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:civilcode, github: "civilcode/civilcode"},
      {:ecto, "~> 2.1"},
      {:ex_machina, "~> 2.2", only: :test},
      {:faker, "~> 0.11.1", only: :test},
      {:mix_test_watch, "~> 0.5", only: :dev, runtime: false},
      {:postgrex, ">= 0.0.0"},
      {:typed_struct, "~> 0.1.3"},
      {:uuid, "~> 1.1"}
    ]
  end

  defp aliases do
    [
      test: ["ecto.migrate", "test"]
    ]
  end
end
