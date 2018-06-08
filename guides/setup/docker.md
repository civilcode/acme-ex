# Setup for docker for Heroku and local development
- [ ] Install distillery
- [ ] Run `mix release.init` and commit the `rel` folder
- [ ] Copy dockerfiles (`./Dockerfile`, `/Dockerfile.dev`, `.docker-compose.yml`)
- [ ] Copy heroku files (`./heroku.yml`, `app.json`)
- [ ] Add config files for staging (`apps/magasin/config/staging.exs`, `apps/magasin_web/config/staging.exs`)
- [ ] Setup distillery to build for staging
- [ ] Setup Magasin.Repo for default credentials from postgres docker image
- [ ] Setup Magasin.Repo to get the DATABASE_URL environment variable (`apps/magasin/lib/magasin/repo.ex`)
- [ ] Setup a package.json in the `assets` folder by running `npm install`
- [ ] Setup `MagasinWeb.Endpoint` for production
```
 config :magasin_web, MagasinWeb.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [host: "localhost", port: {:system, "PORT"}], # This is critical for ensuring web-sockets properly authorize.
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true,
  root: ".",
  version: Application.spec(:magasin_web, :vsn)

```
- [ ] Setup `prod.exs` to not import a `prod.secrets.exs`

## References
- https://cultivatehq.com/posts/elixir-distillery-umbrella-docker/
