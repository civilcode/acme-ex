defmodule MagasinCore.Inventory.StockItem do
  @moduledoc """
  The entity stock item.
  """

  use CivilCode.Aggregate.Root

  alias MagasinCore.Inventory.{OutOfStock, StockItemAdjusted}
  alias MagasinData.Catalog.ProductId
  alias MagasinData.Inventory.StockItemId
  alias MagasinData.Quantity

  embedded_schema do
    field :id, StockItemId
    field :count_on_hand, Quantity
    field :product_id, ProductId
  end

  @spec deplenish(t, Quantity.t()) :: Result.ok(Ecto.Changeset.t(t)) | Result.error(OutOfStock.t())
  def deplenish(stock_item, quantity) do
    case Quantity.subtract(stock_item.count_on_hand, quantity) do
      {:ok, new_count_on_hand} ->
        stock_item_adjusted =
          StockItemAdjusted.new(stock_item_id: stock_item.id, new_count_on_hand: new_count_on_hand)

        stock_item
        |> change(stock_item_adjusted, count_on_hand: new_count_on_hand)
        |> Result.ok()

      {:error, _} ->
        OutOfStock.new(entity: stock_item) |> Result.error()
    end
  end
end
