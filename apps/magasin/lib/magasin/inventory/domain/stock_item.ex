defmodule Magasin.Inventory.Domain.StockItem.State do
  use Magasin.Schema

  schema "magasin_inventory_stock_items" do
    field(:count_on_hand, :integer)
    field(:product_id, :binary_id)

    timestamps()
  end
end
