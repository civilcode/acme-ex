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
      extra_applications: [:logger, :ecto_sql],
      mod: {MagasinData.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:civilcode, github: "civilcode/civilcode-ex"},
      # Uncomment this when update civilcode during Development
      # {:civilcode, path: "../../civilcode-ex"},
      # civilcode-ex uses Ecto 2.x
      {:ecto, "~> 3.1.1", override: true},
      {:ecto_sql, "~> 3.1.0"},
      {:ex_machina, "~> 2.2", only: :test},
      {:faker, "~> 0.11.1", only: :test},
      {:jason, "~> 1.1"},
      {:mix_test_watch, "~> 0.5", only: :dev, runtime: false},
      {:postgrex, ">= 0.0.0"},
      {:uuid, "~> 1.1"}
    ]
  end

  defp aliases do
    [
      test: ["ecto.migrate", "test"]
    ]
  end
end
