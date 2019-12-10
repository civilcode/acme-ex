defmodule MagasinData.System.Event do
  @moduledoc """
  A domain event triggered by the application.
  """
  use CivilCode.Record

  schema "magasin_system_events" do
    field :event_type, :string
    field :data, :map

    timestamps(updated_at: false)
  end
end
