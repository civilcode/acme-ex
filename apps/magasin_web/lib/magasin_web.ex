defmodule MagasinWeb do
  @moduledoc false

  def controller do
    quote do
      use Phoenix.Controller, namespace: MagasinWeb
      import Plug.Conn
      import MagasinWeb.Gettext
      alias MagasinWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/magasin_web/templates",
        namespace: MagasinWeb

      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      use Phoenix.HTML

      import MagasinWeb.ErrorHelpers
      import MagasinWeb.Gettext
      alias MagasinWeb.Router.Helpers, as: Routes
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import MagasinWeb.Gettext
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
