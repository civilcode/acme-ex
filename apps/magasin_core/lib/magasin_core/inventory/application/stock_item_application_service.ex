defmodule MagasinCore.Inventory.StockItemApplicationService do
  @moduledoc """
  The command handler for commands on a stock item aggregate.
  """

  use CivilCode.ApplicationService

  alias MagasinCore.Inventory.{StockItem, StockItemRepository}
  alias MagasinCore.Sales

  def handle(%Sales.OrderPlaced{product_id: product_id, quantity: quantity}) do
    StockItemRepository.transaction(fn ->
      product_id
      |> fetch_stock_item
      |> deplenish_inventory(quantity)
      |> persist
    end)
  end

  defp fetch_stock_item(product_id) do
    StockItemRepository.get_by_product_id(product_id)
  end

  defp deplenish_inventory(stock_item, quantity) do
    StockItem.deplenish(stock_item, quantity)
  end

  defp persist({:ok, changeset}) do
    StockItemRepository.save(changeset)
  end

  defp persist(result), do: result
end
