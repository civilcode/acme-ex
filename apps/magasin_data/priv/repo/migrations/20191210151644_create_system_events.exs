defmodule MagasinData.Repo.Migrations.CreateSystemEvents do
  use Ecto.Migration

  def change do
    create table(:magasin_system_events) do
      add :event_type, :string, null: false
      add :data, :jsonb, null: false

      timestamps(updated_at: false)
    end
  end
end
