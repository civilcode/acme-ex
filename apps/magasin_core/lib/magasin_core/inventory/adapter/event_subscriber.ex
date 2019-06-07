defmodule MagasinCore.Inventory.EventSubscriber do
  @moduledoc false

  use CivilBus.Subscriber, channel: :test

  def handle_event(event, state) do
    {:ok, _} = MagasinCore.Inventory.StockItemApplicationService.handle(event)

    {:noreply, state}
  end

  # Always need to handle unknown messages
  def handle_info(_message, state) do
    {:noreply, state}
  end
end
