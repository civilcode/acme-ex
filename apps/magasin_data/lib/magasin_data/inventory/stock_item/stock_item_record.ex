defmodule MagasinData.Inventory.StockItemRecord do
  @moduledoc false
  use CivilCode.Record

  alias MagasinData.Inventory.StockItemId
  alias MagasinData.Quantity

  @primary_key {:id, StockItemId, autogenerate: false}

  schema "magasin_inventory_stock_items" do
    field :count_on_hand, Quantity
    field :product_id, :binary_id

    timestamps()
  end
end
