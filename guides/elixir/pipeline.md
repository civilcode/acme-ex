# Pipeline Design

## Transforming Collections

The following guidance is _vitally important_:

* design your functions for processing collection of items as you would a single item
* that pattern again: `impure` -&gt; `pure` -&gt; `impure` function calls
* this allows you to leverage lazy evaluation, streaming SQL calls in the future
* See [Collection Pipeline](https://martinfowler.com/articles/collection-pipeline/)
