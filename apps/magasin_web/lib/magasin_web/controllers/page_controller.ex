defmodule MagasinWeb.PageController do
  use MagasinWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
