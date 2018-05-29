defmodule MagasinWeb.PageController do
  use MagasinWeb, :controller

  def index(conn, _params) do
    db_url = Magasin.db_url
    render conn, "index.html", db_url: db_url
  end
end
