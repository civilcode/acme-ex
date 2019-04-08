defmodule MagasinWeb.StringParamController do
  use MagasinWeb, :controller

  def new(conn, %{"nested_id" => nesting_id} = params) do
    IO.inspect(nesting_id)

    render(conn, "new.html")
  end

  def create(conn, params) do
    IO.inspect(params)
  end
end
