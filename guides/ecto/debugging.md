# Debugging Ecto

Here are some common exceptions where the solution might not be so obvious.

## Attempting to cast or change association

    ** (RuntimeError) attempting to cast or change association `client` from `MyApp.Invoicing.Invoice` that was not loaded. Please preload your associations before manipulating them through changesets

If your changeset is not changing the specified association, this means a `Repo.insert` call is
maded instead of a `Repo.update`.

## nil.__struct__/0 is undefined

    ** (UndefinedFunctionError) function nil.__struct__/0 is undefined

This is caused by a `has_many` through association where the leaf association has the wrong name.
For example `has_many :reviewers, through: [comments: :authors]`,
should have been `has_many :reviewers, through: [comments: :author]` (i.e. the author association
is not plural).
