# Programming with Types

## Influences

The following books have been an influence on the use of types

- [Secure by Design](https://www.manning.com/books/secure-by-design)
- [Domain Modeling Made Functional](https://pragprog.com/book/swdddf/domain-modeling-made-functional)

And the following blog posts:

- [Designing with types](https://fsharpforfunandprofit.com/series/designing-with-types.html)
- [Monoids without tears](https://fsharpforfunandprofit.com/posts/monoids-without-tears/#series-toc)

## Discovering types

We model to identify Entities as types, see: [Object Modeling in Color (OMC)](https://civilcode.gitbook.io/playbook/education/trails/object-modeling).
  - **Moment-Interval** (aka Events)
  - **Role**
  - **PPT**
  - catalog-entry-like **Description** (a collection of values that apply again and again)
    - a Description is an Entity
    - not to be confused with a type property

# Why do we use types?

- excellent form of documentation
- make explicit states unrepresentable (i.e. business rules)
- handling conditional logic explicitly

##  What do we use types for?

- entities (via typedstruct), a bag of domain primitives
- domain primitives (i.e wrapping primitives)
- union types (specialization of a entity or domain primitive)
- product types (1 or more types)

## What good candidates for union types?

- existing types used in conditional logic based on a property
- state: lifecycle and operational
- role
- type-classifications (e.g room that is smoking or non-smoking)

## How do we define types in Elixir?

- for entities and value object using "[typed_struct](https://github.com/ejpcmac/typed_struct)"
- value objects, wrapping a single Elixir primitive `use CivilCode.ValueObject, type: :string`
- value objects, as a product type (e.g. `Address`)
- aliasing types `deftype EmailOnly, EmailContact`
- product types: `deftype EmailAndPostal, {EmailContact, PostalContact}` (note: express as a tuple)
- union types: `deftype ContactInfo, EmailOnly | PostalOnly | EmailAndPostal`

Ref: https://fsharpforfunandprofit.com/posts/overview-of-types-in-fsharp/#sum-and-product-types

## What not just use type aliasing?

- explicit types to ensure our code is secure (e.g. Secure by Design)
- you cannot pattern match on the aliases

## Why structs for types?

- enables the use of protocols
- it's just an atom in a map

## How do we use types in Elixir?

- pattern matching
  - within function heads
  - with case statement
- all cases MUST be matched

# Related rules to keep in mind

- entity are just a bag of domain primitives that enforce a variant
- domain primitives MUST not have knowledge of entities

## Defining types

- `enforce: true` SHOULD always be used (e.g. `typedstruct enforce: true do ...`)
- optional fields MUST use `Maybe.t`
- optional fields strongly indicate a new type, you SHOULD consider defining a new type
- entities and Domain Primitives are represented by algebraic types; e.g. `Order.t`, `Quantity.t`
- create a specialized typed when you need different fields on that type; e.g. `type Account :: CheckingAccount.t | SavingsAccount.t`, a `SavingsAccount.t` requires a `RateofInterest.t`.
- consider creating a new type, especially an element of a union type if it clarifies business logic.
- it's ok to have types named with type in them; e.g. `type TaxType :: Tax.t | Fee.t | Commission.t`
