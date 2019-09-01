defmodule MagasinData.Inventory.StockItemRecord do
  @moduledoc false
  use CivilCode.Record

  @primary_key {:id, :binary_id, autogenerate: false}

  schema "magasin_inventory_stock_items" do
    field :count_on_hand, :integer
    field :product_id, :binary_id

    timestamps()
  end
end
