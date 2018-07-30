defmodule Magasin.Inventory.Domain.StockItem do
  @moduledoc false

  use CivilCode.Aggregate

  alias Magasin.Inventory.Domain.{OutOfStock, StockItemAdjusted}
  alias Magasin.Quantity

  def deplenish(stock_item, quantity) do
    apply_event(stock_item, fn state ->
      case Quantity.subtract(state.count_on_hand, quantity) do
        {:ok, new_count_on_hand} ->
          {:ok, %StockItemAdjusted{stock_item_id: state.id, new_count_on_hand: new_count_on_hand}}

        {:error, _} ->
          {:error, error(stock_item, %OutOfStock{entity: stock_item})}
      end
    end)
  end
end
