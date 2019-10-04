# The Elixir Style Guide Amendments

## Table of Contents

* [Introduction](style.md#introduction)
* [The Guide](style.md#the-guide)
  * [Source Code Layout](style.md#source-code-layout)
  * [Syntax](style.md#syntax)  
  * [Typespec](style.md#typespecs)
  * [Documentation](style.md#documentation)    

## Introduction

This documents outlines amendments to the [Elixir Community Style Guide](https://github.com/christopheradams/elixir_style_guide). These amendments are items that are not covered in the Community Guide or in very rare cases where we deviate from the community standard.

## The Guide

### Source Code Layout

* Indention kills readability. If the body of the function is indented more than three soft tabs

  \(i.e. 6 spaces\), that is a smell that functions should be extracted, reducing the indention.

  \[[link](style.md#indentation)\]     

### Syntax

*  Do not visually "break" the pipeline; i.e. when piping into function that is formatted across multiple lines, extract that into a single line function. \[[link](style.md#pipeline)\]

  ```elixir
  # not preferred
  foo
  |> Enum.map(fn(%{bar: bar, qux: qux}) ->
        upcased = String.upcase(bar)
        {:ok, upcased, qux}
    end)
  |> baz

  # preferred
  foo
  |> Enum.map(&extracted_function/1)
  |> baz

  def extracted_function(%{bar: bar, qux: qux}) do
    upcased = String.upcase(bar)
    {:ok, upcased, qux}
  end
  ```

*  The head of the `with` macro should have single function calls. \[[link](style.md#with-else)\]

  ```elixir
  with {:ok, foo} <- fetch(opts, :foo),
       {:ok, bar} <- fetch(opts, :bar)
  do
    {:ok, foo, bar}
  else
    :error ->
      {:error, :bad_arg}
  end
  ```

*  Do not use `Map.put/3` with a struct as it is possible to put a new key in the struct that that does not exist. Use `Map.replace!/3` instead or the merge syntax. \[[link](style.md#map-put-struct)\]

  ```elixir
  # not preferred
  Map.put(my_struct, :bar, "foo")

  # preferred
  Map.replace!(my_struct, :bar, "foo")

  # ideal
  %{my_struct | bar: "foo"}
  ```

*  When selecting a macro to implement a conditional statement, e.g. `if`, `case`, or `with`, it is easy to select a more complex macro than is required. We should always use the simplest macro to express our intent. \[[link](style.md#conditional-macros)\]

  ```elixir
  # not preferred
  case foo(bar) do
    true -> baz()
    _ -> nil
  end

  # preferred
  if foo(bar) do
    baz()
  end

  # not preferred
  case foo(bar) do
    true -> baz()
    false -> qux()
  end

  # preferred
  if foo(bar) do
    baz()
  else
    qux()
  end

  # not preferred
  with {:ok, bar} <- foo() do
    baz()
  else
    _ -> qux()
  end

  # preferred
  case foo() do
    {:ok, bar} -> baz()
    _ -> qux()
  end
  ```

* Keyword lists are generally used for passing options in a function. They should not be used as a key-value
  store as they allow for duplicate keys. Ref: [Elixir Guides](https://elixir-lang.org/getting-started/keywords-and-maps.html#keyword-lists) [[link](style.md#keyword-lists)]

### Naming

*   Treat acronyms as words in names \(XmlHttpRequest not XMLHTTPRequest\), even if the acronym is the entire name \(class Html not class HTML\).

    \[[link](style.md#acronyms)\]

## Typespecs

* Add typespecs for all public functions.

  \[[link](style.md#typespecs-required)\]

## Documentation

* do not provide module-level documentation for modules suffixed with their archetype \(e.g. `Service`, `Controller`, `Query`, `Repo`\)
* apply `@module false` to these modules.
* [typespec](http://elixir-lang.org/getting-started/typespecs-and-behaviours.html#types-and-specs) is mandatory for public functions \(except in controllers and views\)
