Path.join(["rel", "plugins", "*.exs"])
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Mix.Releases.Config,
  default_release: :default,
  default_environment: Mix.env()

environment :dev do
  set(dev_mode: true)
  set(include_erts: false)
  set(cookie: :"uE(:/nUb.yF[(FSkI^BAU`(>a2=Gj;_!yM,i}c`%e>l!5&Znv{|D/YWZwE]NwOF|")
end

environment :staging do
  set(include_erts: true)
  set(include_src: false)
  set(cookie: :"KYY?g&*R>bH$!OT@yycvnL$Nr:v8/J>x^m_pnsjnM7;?N{Ss]p[`QhJB]s7l%7?U")
end

environment :prod do
  set(include_erts: true)
  set(include_src: false)
  set(cookie: :"2SY?g&*H>bH$!OT@yycvnL$Nr:v8/J>x^m_pnsjnM7;?N{Ss]p[`QhJB]s7l%7?U")
end

release :acme_platform do
  set(
    version: "0.1.0",
    applications: [
      :runtime_tools,
      magasin: :permanent,
      magasin_web: :permanent
    ],
    commands: [migrate: "rel/commands/migrate.sh"],
    config_providers: [
      {
        Mix.Releases.Config.Providers.Elixir,
        ["${RELEASE_ROOT_DIR}/etc/config.exs"]
      }
    ],
    overlays: [{:copy, "rel/config/config.exs", "etc/config.exs"}]
  )
end
