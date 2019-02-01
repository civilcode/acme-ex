defmodule AcmePlatform.MixProject do
  use Mix.Project

  def project do
    [
      aliases: aliases(),
      apps_path: "apps",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      version: "0.0.0",
      dialyzer: [
        flags: [
          :unmatched_returns,
          :error_handling,
          :race_conditions,
          :underspecs,
          :no_opaque
        ],
        plt_add_deps: :transitive,
        plt_add_apps: [:mix],
        ignore_warnings: "dialyzer.ignore-warnings"
      ],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.html": :test,
        "project.check": :test,
        dialyzer: :test
      ],
      test_coverage: [tool: ExCoveralls]
    ]
  end

  defp aliases do
    [
      "project.seed": ["run apps/magasin/priv/seeds.exs"],
      "project.setup": ["ecto.drop", "ecto.create", "ecto.migrate", "project.seed"],
      "project.check": [
        "compile --force --warnings-as-errors",
        "coveralls --umbrella --timeout 1000",
        "credo --strict",
        "dialyzer"
      ]
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
      {:distillery, "~> 2.0", runtime: false},
      {:dialyxir, "~> 0.5", only: [:dev, :test], runtime: false},
      {:credo, "~> 0.9.1", only: [:dev, :test], runtime: false},
      {:civil_credo,
       github: "civilcode/civil-credo", branch: "master", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.19", runtime: false},
      {:excoveralls, "~> 0.8", only: :test}
    ]
  end
end
