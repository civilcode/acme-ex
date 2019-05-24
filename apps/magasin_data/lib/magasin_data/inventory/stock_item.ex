defmodule MagasinData.Inventory.StockItem do
  @moduledoc false
  use MagasinData.Schema

  alias MagasinData.Inventory.StockItemId
  alias MagasinData.Quantity

  @primary_key {:id, StockItemId, autogenerate: false}

  schema "magasin_inventory_stock_items" do
    field :count_on_hand, Quantity
    field :product_id, :binary_id

    timestamps()
  end
end
