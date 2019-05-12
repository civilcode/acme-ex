defmodule MagasinWeb.Router do
  @moduledoc false

  use MagasinWeb, :router

  secure_headers =
    [
      "default-src 'self'",
      "img-src 'self' data:",
      "connect-src 'self'",
      "frame-src 'self'",
      "script-src 'self' 'unsafe-eval'",
      "style-src 'self' 'unsafe-inline' 'unsafe-eval'"
    ]
    |> Enum.join(";")

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers, %{"content-security-policy" => secure_headers})
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", MagasinWeb do
    pipe_through(:browser)

    get("/", PageController, :index)
  end
end
