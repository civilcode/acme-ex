defmodule MagasinData.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # %{
      #   id: CivilBus,
      #   start: {CivilBus, :start_link, []}
      # },
      MagasinData.Repo
    ]

    opts = [strategy: :one_for_one, name: MagasinData.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
