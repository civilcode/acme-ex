defmodule MasterProxy.Application do
  @moduledoc false
  require Logger

  use Application

  def start(_type, _args) do
    :ok = Logger.info("Running proxy")

    http_config = Application.get_env(:master_proxy, :http)
    cowboy = Plug.Cowboy.child_spec(scheme: :http, plug: MasterProxy.Plug, options: http_config)

    children = [
      # Starts a worker by calling: Proxy.Worker.start_link(arg)
      # {Proxy.Worker, arg},
      cowboy
    ]

    opts = [strategy: :one_for_one, name: MasterProxy.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
