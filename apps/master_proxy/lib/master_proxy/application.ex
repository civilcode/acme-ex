defmodule MasterProxy.Application do
  @moduledoc false

  alias Phoenix.LiveReloader.Socket, as: LiveReloadSocket
  alias Plug.Cowboy

  use Application

  require Logger

  def start(_type, _args) do
    http_config = Application.get_env(:master_proxy, :http)

    {:ok, pid} = in_phoenix?() |> children(http_config) |> run_application()
    :ok = Logger.info("Successfully started master_proxy on port #{to_port(http_config[:port])}")
    {:ok, pid}
  end

  defp run_application(children) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link(
      children,
      strategy: :one_for_one,
      name: MasterProxy.Supervisor
    )
  end

  defp children(false = _start_cowboy, _http_config), do: []

  defp children(true = _start_cowboy, http_config) do
    [
      Cowboy.child_spec(
        # since we're using manual dispatch, plug is ignored
        plug: nil,
        scheme: :http,
        options: [
          port: to_port(http_config[:port]),
          dispatch: [
            {:_,
             [
               websocket_handler(
                 "/phoenix/live_reload/socket/websocket",
                 MagasinWeb.Endpoint,
                 {LiveReloadSocket, :websocket}
               ),
               websocket_handler(
                 "/socket/websocket",
                 MagasinWeb.Endpoint,
                 {MagasinWeb.UserSocket, websocket: true}
               ),
               {:_, Cowboy.Handler, {MasterProxy.Plug, []}}
             ]}
          ]
        ]
      )
    ]
  end

  defp websocket_handler(path, endpoint, options) do
    {path, Phoenix.Endpoint.Cowboy2Handler, {endpoint, options}}
  end

  # we only want the proxy to start when phoenix is started as well
  # (not in iex or tests)
  defp in_phoenix? do
    Application.get_env(:phoenix, :serve_endpoints)
  end

  defp to_port(nil) do
    :ok =
      Logger.error(
        "Server can't start because :port in config is nil, please use a valid port number"
      )

    exit(:shutdown)
  end

  defp to_port(binary) when is_binary(binary), do: String.to_integer(binary)
  defp to_port(integer) when is_integer(integer), do: integer
  defp to_port({:system, env_var}), do: to_port(System.get_env(env_var))
end
