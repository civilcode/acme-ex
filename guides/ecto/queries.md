# Ecto - Queries

## Design Guide

- Design the query as a series of data transformations on a result set.
- Transformations will be mostly filtering a base relation.
- Optimize for delete-ability, so a transformation can easily be deleted.

## Function Names

- start with the base relation (i.e. schema)
- `filter_*`: filter the result set (where, join)
- `include_*`: include associated records with those in the result set (where outer join)
- `order`: specify the how the result set should be order
- `select`: select the fields from the result set

Example:

```elixir
Transaction
|> filter_client(client_id)
|> include_security_quote
|> filter_cash_flows(cash_or_managed_security_codes, unmanaged_security_codes)
|> order
|> select
```
