defmodule MagasinCore.CatalogFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias MagasinCore.Catalog

      def catalog_product_id_factory do
        Catalog.ProductRepository.next_id()
      end
    end
  end
end
