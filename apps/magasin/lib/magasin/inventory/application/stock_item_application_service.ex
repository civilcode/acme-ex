defmodule Magasin.Inventory.Application.StockItemApplicationService do
  @moduledoc false

  use CivilCode.ApplicationService

  alias Magasin.Inventory.Application.StockItemRepository
  alias Magasin.Inventory.Domain.StockItem
  alias Magasin.Sales

  def handle(%Sales.Domain.OrderPlaced{product_id: product_id, quantity: quantity}) do
    product_id
    |> fetch_stock_item
    |> deplenish_inventory(quantity)
    |> persist
  end

  defp fetch_stock_item(product_id) do
    StockItemRepository.get_by_product_id(product_id)
  end

  defp deplenish_inventory(stock_item, quantity) do
    StockItem.deplenish(stock_item, quantity)
  end

  defp persist({:ok, stock_item}) do
    StockItemRepository.save(stock_item)
  end

  defp persist(result), do: result
end
