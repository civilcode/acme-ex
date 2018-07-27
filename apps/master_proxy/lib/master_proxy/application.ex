defmodule MasterProxy.Application do
  @moduledoc false
  require Logger

  use Application

  def start(_type, _args) do
    :ok = Logger.info("Running proxy")

    http_config = Application.get_env(:master_proxy, :http)
    cowboy = Plug.Adapters.Cowboy.child_spec(:http, MasterProxy.Plug, [], http_config)

    children = [
      # Starts a worker by calling: Proxy.Worker.start_link(arg)
      # {Proxy.Worker, arg},
      cowboy
    ]

    opts = [strategy: :one_for_one, name: MasterProxy.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
