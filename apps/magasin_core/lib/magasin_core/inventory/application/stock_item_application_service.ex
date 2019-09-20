defmodule MagasinCore.Inventory.StockItemApplicationService do
  @moduledoc """
  The command handler for commands on a stock item aggregate.
  """

  use CivilCode.ApplicationService

  alias MagasinCore.Inventory.{OutOfStock, StockItem, StockItemRepository}
  alias MagasinCore.Sales

  @spec handle(Sales.OrderPlaced.t()) :: Result.t(StockItem.t(), OutOfStock.t())
  def handle(%Sales.OrderPlaced{} = command) do
    StockItemRepository.transaction(fn ->
      with {:ok, stock_item} <- StockItemRepository.get_by_product_id(command.product_id),
           {:ok, updated_stock_item} <- StockItem.deplenish(stock_item, command.quantity) do
        StockItemRepository.save(updated_stock_item)
      end
    end)
  end
end
