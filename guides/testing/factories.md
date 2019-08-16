# Test Factories

## Style

- a factory MUST have valid fields
- a factory CAN build another factory for a `belongs_to` association, a factory MUST NOT build
  factories for a `has_many` association

## Life cycle or operational states

State is encapsulated by a function:

```elixir
# good

:order
|> build
|> as_complete

# bad

build(:order, state: "complete", completed_at: DateTime.utc_now)
```

Benefits:

* encompasses what is required to make the entity a specific state \(it might be more than two attributes\)
* if the state implementation changes, it can be refactored in once place
* it avoids "magic strings" throughout the code base

## Naming conventions

The prefix (i.e. module) should be in the singular form which helps to make the factory name read
better (very much like we do with table names). Since this will result in
`benchmark_benchmark_security_factory` we can eliminate the duplication: `benchmark_security_factory`.
