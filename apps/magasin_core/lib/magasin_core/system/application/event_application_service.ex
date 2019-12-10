defmodule MagasinCore.System.EventApplicationService do
  @moduledoc """
  The event handler for domain events.
  """

  use CivilCode.ApplicationService

  @spec handle(struct) :: Result.ok(EntityId.t())
  def handle(%event_type{} = event) do
    system_event =
      MagasinData.Repo.insert!(%MagasinData.System.Event{
        event_type: to_string(event_type),
        data: Map.from_struct(event)
      })

    Result.ok(system_event.id)
  end
end
