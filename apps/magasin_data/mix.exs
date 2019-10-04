defmodule MagasinData.MixProject do
  use Mix.Project

  def project do
    [
      app: :magasin_data,
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
      extra_applications: [:logger, :ecto_sql, :ssl],
      mod: {MagasinData.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Uncomment this when updating during development
      # {:civil_bus, path: "../../packages/civil-bus"},
      {:civil_bus, github: "civilcode/civil-bus"},
      # Uncomment this when updating during development
      # {:civilcode, path: "../../packages/civilcode-ex"},
      {:civilcode, github: "civilcode/civilcode-ex"},
      # civilcode-ex uses Ecto 2.x
      {:ecto_sql, "~> 3.2.0"},
      {:elixir_uuid, "~> 1.1"},
      {:eventstore, "~> 0.16"},
      {:ex_machina, "~> 2.3", only: :test},
      {:faker, "~> 0.11.1", only: :test},
      {:jason, "~> 1.1"},
      {:mix_test_watch, "~> 0.5", only: :dev, runtime: false},
      {:postgrex, ">= 0.0.0"}
    ]
  end

  defp aliases do
    [
      test: ["ecto.migrate", "test"]
    ]
  end
end
