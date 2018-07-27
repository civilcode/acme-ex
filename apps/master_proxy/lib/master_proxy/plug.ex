defmodule MasterProxy.Plug do
  @moduledoc """
  This plug will route the traffic to the corresponding umbrella applications
  """

  def init(options) do
    options
  end

  def call(conn, _opts) do
    # cond do
    # String.match?(conn.host, ~r/^other_endpoint.*/) ->
    #   OtherAppWeb.Endpoint.call(conn, [])

    # true ->
    MagasinWeb.Endpoint.call(conn, [])
    # end
  end
end
