defmodule MasterProxy.PlugTest do
  use ExUnit.Case

  import Phoenix.ConnTest, only: [build_conn: 0]

  test "init" do
    init_options = [some: :options]

    result = MasterProxy.Plug.init(init_options)

    assert result == init_options
  end

  test "Pass all traffic through" do
    conn = build_conn()

    response = MasterProxy.Plug.call(conn, [])

    assert response.status == 200
  end
end
