# Ecto - Migrations

* a field MUST have an explicit `null: true|false` even though the default is `true` (this
  communicates the setting `null` has been explicitly considered, rather than overlooked)
* a foreign constraint SHOULD have a `:on_delete - :delete_all` if the referenced entry is deleted.
