defmodule MagasinCore.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [MagasinCore.Inventory.EventSubscriber]

    opts = [strategy: :one_for_one, name: MagasinCore.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
