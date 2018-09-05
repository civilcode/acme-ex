defmodule Magasin.Inventory.Domain.StockItem.State do
  @moduledoc false

  use Magasin.Schema

  alias Magasin.Inventory.Domain.{StockItemAdjusted, StockItemId}
  alias Magasin.Quantity

  @primary_key {:id, StockItemId.Ecto.Type, autogenerate: false}

  schema "magasin_inventory_stock_items" do
    field(:count_on_hand, Quantity.Ecto.Type)
    field(:product_id, :binary_id)

    timestamps()
  end

  def apply(state, %StockItemAdjusted{} = event) do
    change(state, count_on_hand: event.new_count_on_hand)
  end
end
