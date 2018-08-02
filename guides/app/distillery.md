# Distillery

## Setup for a release

1. Install Distillery
2. Run `mix release.init` and commit the `rel` folder
3. Add config files for staging `config/staging.exs`
4. Setup Distillery with staging in `rel/config.exs`
6. Setup a `package.json` in the `assets` folder by running `npm install`
7. Setup `MagasinWeb.Endpoint` for production

    config :magasin_web, MagasinWeb.Endpoint,
      http: [port: {:system, "PORT"}],
      url: [host: "localhost", port: {:system, "PORT"}], # This is critical for ensuring web-sockets properly authorize.
      cache_static_manifest: "priv/static/cache_manifest.json",
      server: true,
      root: ".",
      version: Application.spec(:magasin_web, :vsn)

8. Setup `prod.exs` to not import a `prod.secrets.exs`
