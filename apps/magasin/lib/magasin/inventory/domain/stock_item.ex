defmodule Magasin.Inventory.Domain.StockItem do
  @moduledoc false

  use CivilCode.Aggregate

  alias Magasin.Catalog.Domain, as: Catalog
  alias Magasin.Inventory.Domain.{OutOfStock, StockItemAdjusted, StockItemId}
  alias Magasin.Quantity

  typedstruct do
    field :id, StockItemId.t()
    field :count_on_hand, Quantity.t()
    field :product_id, Catalog.ProductId.t()

    field :__entity__, CivilCode.Entity.Metadata.t()
  end

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

  def apply(struct, %StockItemAdjusted{} = event) do
    CivilCode.Entity.put_changes(struct, count_on_hand: event.new_count_on_hand)
  end
end
