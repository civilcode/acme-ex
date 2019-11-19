# Understanding (re-)compilation in Elixir

When a large amount of files are recompiled when a single file is touched, you may have a
compile dependency issue. This can easily happen in a Phoenix application when cyclic compile dependencies
are created with view and controllers importing functions from each other.

The best way to understand these concepts is to watch the conference talk and if necessary read the blog post,
both authored by Renan Ranelli:

- [Understanding Elixir's (re-)compilation](https://www.youtube.com/watch?v=hqaxMZAwbBA) - ElixirConf 2018
- [Understanding Elixir's recompilation](https://milhouse.dev/2016/08/11/understanding-elixir-recompilation/) - Blog post

## Summary

There are type types of dependencies in Elixir:

1. runtime depdencency
2. compile-time dependency

_What creates a run-time dependency?_

When module "A" calls a function from module "B".

_What creates a compile-time dependency?_

For example, when Module "A" calls a macro from Module "B". When module "B" is changed, module "A" will be recompiled.

The complete list of compile-time dependencies are created when:

- a module is `{import, require, use}`d
- when a struct is reference with the `%MODULE{}` syntax
- when implementing protocols
- when implementing behaviours
- when an atom is "seen" on macro-expansion (i.e a module name)

What is a transitive dependency?

A transitive dependency can be created in a graph of modules which is not displayed by `mix xref graph`. e.g.

```
Mod0 --(compile)--> Mod1 --(runtime)--> Mod2
```

Mod0 has a compile dependency on Mod1, and Mod1 has a runtime dependency on Mod2. If Mod2 changes, Mod0 and Mod1 will be recompiled. Therefore an implicit compile-time dependency is formed between Mod0 and Mod2. e.g.

```
Mod0 --(compile) --> Mod2
```

In summary (from "Understanding Elixir's (re-)compilation"):

> if module "A" is modified, every other module with a path to "A" that contains at least one edge labeled "compile", will be recompile.


## Tips

- use `mix test.watch --only nothing` to touch files and see how many are compiled
- this can be used with `inotifywait` to see filenames compiled (see tools below)
- use `mix xref graph` to identify compile dependencies, starting with `mix xref graph --format stats --label compile` to see the most outgoing and incoming dependencies
- is the `config/dev.exs` missing `config :phoenix, :plug_init_mode, :runtime`? see [What's new in Phoenix development - February 2018; Faster development compilation](https://dockyard.com/blog/2018/02/12/what-s-new-in-phoenix-development-february-2018)
- is the `Routes` alias used? see [What's new in Phoenix development - February 2018; Explicit Router helper aliases](https://dockyard.com/blog/2018/02/12/what-s-new-in-phoenix-development-february-2018)
- as a last resort, use `Macro.concat(["MyModule"])` to "hide" the module atom.


## Tools

```
# To list which files are compiled
inotifywait -rm -e MODIFY`, e.g. `inotifywait -rm -e MODIFY _build/test/ | grep 'magasin_web/ebin/ .*\.beam$'

# To get all files that depend on lib/foo.ex
mix xref graph --sink lib/foo.ex --only-nodes

# To get all files that depend on lib/foo.ex at compile time
mix xref graph --label compile --sink lib/foo.ex --only-nodes

# To show general statistics about the graph
mix xref graph --format stats

# To limit statistics only to certain labels
mix xref graph --format stats --label compile
```
