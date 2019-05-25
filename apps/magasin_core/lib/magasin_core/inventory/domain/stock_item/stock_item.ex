defmodule MagasinCore.Inventory.StockItem do
  @moduledoc """
  The entity stock item.
  """

  use CivilCode.Aggregate.Root

  alias MagasinCore.Inventory.{OutOfStock, StockItemAdjusted}
  alias MagasinData.Catalog.ProductId
  alias MagasinData.Inventory.StockItemId
  alias MagasinData.Quantity

  typedstruct do
    field :id, StockItemId.t()
    field :count_on_hand, Quantity.t()
    field :product_id, ProductId.t()
  end

  # Public API

  def deplenish(stock_item, quantity) do
    update(stock_item, fn state ->
      case Quantity.subtract(state.count_on_hand, quantity) do
        {:ok, new_count_on_hand} ->
          {:ok,
           StockItemAdjusted.new(stock_item_id: state.id, new_count_on_hand: new_count_on_hand)}

        {:error, _} ->
          {:error, OutOfStock.new(entity: stock_item)}
      end
    end)
  end

  # State Mutators

  @doc false
  def apply(stock_item, %StockItemAdjusted{} = event) do
    put_changes(stock_item, count_on_hand: event.new_count_on_hand)
  end
end
