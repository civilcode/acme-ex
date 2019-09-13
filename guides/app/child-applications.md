# Child Applications

## What are child apps?

- we architect our projects as elixir umbrella apps with many child apps, which are contained in the `apps` folder of the project

## Why create child apps?

- to isolate concerns in top-level namespaces
- to enable control over which namespaces are included in various deployment environments
- to facilitate testing only certain namespaces

## How to create a new child app

- from root, `cd apps && mix new <app_name>`
- write a descriptive `README.md`
- remove boilerplate from `<app_name>.ex`
- remove `<app_name>_test.exs` boilerplate
- add the app to `rel/config.exs` where appropriate

# When to create a new child app

- to encapsulate a domain-driven design *Bounded Context* OR
- to contain functionality that isn't a business subdomain but nonetheless represents a distinct concern (e.g. a set of library functions)
