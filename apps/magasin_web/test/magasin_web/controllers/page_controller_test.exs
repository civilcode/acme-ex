defmodule MagasinWeb.PageControllerTest do
  use MagasinWeb.ConnCase

  @moduletag timeout: 1_000

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end
end
