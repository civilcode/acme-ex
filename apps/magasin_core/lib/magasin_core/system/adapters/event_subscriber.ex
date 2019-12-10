defmodule MagasinCore.System.EventSubscriber do
  @moduledoc false

  use CivilBus.Subscriber, channel: :domain_events, consistency: :strong

  def handle_event(event, state) do
    {:ok, _} = MagasinCore.System.EventApplicationService.handle(event)

    {:noreply, state}
  end

  # Always need to handle unknown messages
  def handle_info(_message, state) do
    {:noreply, state}
  end
end
