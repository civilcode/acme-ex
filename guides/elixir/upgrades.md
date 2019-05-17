# Upgrade Guide

## MINOR and PATCH updates with no version change in `mix.exs`

1. Create a branch
    git checkout chore/upgrade-packages
2. List outdated packages
    mix hex.outdated
3. For each package where `"Update possible"`:

```
mix deps.update {package-name}
mix test
git add -p
git commit -m "chore: Upgrade {package-name} 0.1.0 => 0.2.0"
```

Note: Upgrade message can be copied from the output of `mix deps.update`.

After doing a batch of updates you SHOULD run the following command to remove any used packages:

    `mix deps.unlock --unused`

## MINOR and MAJOR updates with version change in `mix.exs`

- For these updates you SHOULD consider a separate PR, especially MAJOR updates to key packages
  such as `ecto` and `phoenix`.
- Follow the procedure outlined above to make the updates, but you will need to update the version
  in `mix.exs` first.
- If the updates required resolving many deprecation warnings you SHOULD consider resolving
  these in a PR with previous version (i.e. fix with the new version, then the last commit
  roll backs to the previous version). This can be convenient if the package update cannot
  be done immediately, e.g. issues with `dialyzer`.
- Major updates may require a cache boost for `.circle.ci/config.yml` to avoid issues with Dialyzer. For example, the upgrade for `Ecto 2.x => 3.x` required this, especially when there are other branches build on CI that are using older versions.

## Overriding dependencies in an Umbrella Application

When overriding dependencies in an umbrella application, you must override dependency in
each child app that has an explicit or implicit dependencies. In example message below, an override
has been made in the the `magasin` application for `ecto 3.0.0-rc.1`, but it also needs to be
made in the `magasin_web` application.

    mix deps.get
    Resolving Hex dependencies...

    Failed to use "ecto" because
      apps/magasin_web/mix.exs requires ~> 3.0-rc.1
      dataloader (version 1.0.4) requires >= 0.0.0 *
      mix.lock specifies 3.0.0-rc.1

    ** (Mix) Hex dependency resolution failed, change the version requirements of your dependencies or unlock them (by using mix deps.update or mix deps.unlock). If you are unable to resolve the conflicts you can try overriding with {:dependency, "~> 1.0", override: true}

## Upgrade Elixir

1. Update base images for Dockerfiles, including release stage image (Alpine version), if applicable
2. Increment the cache in `.circle.ci/config.yml`
3. Commit with:
    git commit -m "chore: Upgrade Elixir 1.7.3 => 1.8.1"
