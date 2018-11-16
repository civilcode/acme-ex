# Dependencies

## Overriding dependencies in an Umbrella Application

When overriding dependencies in an umbrella application, you must override dependency in
each child app that has an explicit or implicit dependencies. In example message below, an override
has been made in the the `magasin` application for `ecto 3.0.0-rc.1`, but it also needs to be
made in the `magasin_web` application.

```
mix deps.get
Resolving Hex dependencies...

Failed to use "ecto" because
  apps/magasin_web/mix.exs requires ~> 3.0-rc.1
  dataloader (version 1.0.4) requires >= 0.0.0 *
  mix.lock specifies 3.0.0-rc.1

** (Mix) Hex dependency resolution failed, change the version requirements of your dependencies or unlock them (by using mix deps.update or mix deps.unlock). If you are unable to resolve the conflicts you can try overriding with {:dependency, "~> 1.0", override: true}
```
