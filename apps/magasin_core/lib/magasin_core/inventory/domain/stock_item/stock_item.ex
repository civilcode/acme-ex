defmodule MagasinCore.Inventory.StockItem do
  @moduledoc """
  The entity stock item.
  """

  use CivilCode.AggregateRoot

  alias MagasinCore.Catalog.ProductId
  alias MagasinCore.Inventory.{OutOfStock, StockItemAdjusted, StockItemId}
  alias MagasinCore.Quantity

  schema do
    field :id, StockItemId.t()
    field :count_on_hand, Quantity.t()
    field :product_id, ProductId.t()
  end

  @spec deplenish(t, Quantity.t()) :: Result.t(t, OutOfStock.t())
  def deplenish(stock_item, quantity) do
    case Quantity.subtract(stock_item.count_on_hand, quantity) do
      {:ok, new_count_on_hand} ->
        stock_item_adjusted =
          StockItemAdjusted.new(stock_item_id: stock_item.id, new_count_on_hand: new_count_on_hand)

        stock_item
        |> apply_event(stock_item_adjusted)
        |> Result.ok()

      {:error, _} ->
        OutOfStock.new(entity: stock_item) |> Result.error()
    end
  end

  defp apply_event(state, %StockItemAdjusted{} = event) do
    state
    |> Map.put(:count_on_hand, event.new_count_on_hand)
    |> put_event(event)
  end
end
