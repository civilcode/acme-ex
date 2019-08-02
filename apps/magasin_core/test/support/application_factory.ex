defmodule MagasinCore.ApplicationFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      use MagasinCore.SalesFactory
      use MagasinCore.CatalogFactory
    end
  end
end
