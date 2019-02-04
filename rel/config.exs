["rel", "plugins", "*.exs"]
|> Path.join()
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Mix.Releases.Config,
  default_release: :default,
  default_environment: Mix.env()

environment :staging do
  set(include_erts: true)
  set(include_src: false)
  set(cookie: :"KYY?g&*R>bH$!OT@yycvnL$Nr:v8/J>x^m_pnsjnM7;?N{Ss]p[`QhJB]s7l%7?U")

  set(
    config_providers: [
      {
        Mix.Releases.Config.Providers.Elixir,
        ["${RELEASE_ROOT_DIR}/etc/runtime.exs"]
      },
      {
        Mix.Releases.Config.Providers.Elixir,
        ["${RELEASE_ROOT_DIR}/etc/staging.exs"]
      }
    ],
    overlays: [
      {:copy, "rel/config/runtime.exs", "etc/runtime.exs"},
      {:copy, "rel/config/staging.exs", "etc/staging.exs"}
    ]
  )
end

release :acme_platform_staging do
  set(
    version: "0.0.0",
    applications: [
      :civilcode,
      :runtime_tools,
      magasin: :permanent,
      magasin_web: :permanent,
      master_proxy: :permanent
    ],
    commands: [migrate: "rel/commands/migrate.sh"]
  )
end
