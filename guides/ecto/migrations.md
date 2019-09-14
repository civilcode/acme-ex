# Ecto - Migrations

## Names

* `Date` MUST use the suffix `on`, e.g. `issued_on`
* `DateTime` MUST use the suffix `at`, e.g. `issued_at`

## Options

* a field MUST have an explicit `null: true|false` even though the default is `true` (this
  communicates the setting `null` has been explicitly considered, rather than overlooked)
* a foreign constraint SHOULD have a `:on_delete - :delete_all` if the referenced entry is deleted, e.g.:
  `add :author_id, references("posts", on_delete: :delete_all), null: false)`
