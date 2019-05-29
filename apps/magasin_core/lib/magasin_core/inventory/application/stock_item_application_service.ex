defmodule MagasinCore.Inventory.StockItemApplicationService do
  @moduledoc """
  The command handler for commands on a stock item aggregate.
  """

  use CivilCode.ApplicationService

  alias MagasinCore.Inventory.{StockItem, StockItemRepository}
  alias MagasinCore.Sales

  def handle(%Sales.OrderPlaced{} = command) do
    StockItemRepository.transaction(fn ->
      with {:ok, stock_item} <- StockItemRepository.get_by_product_id(command.product_id),
           {:ok, changeset} <- StockItem.deplenish(stock_item, command.quantity) do
        StockItemRepository.save(changeset)
      end
    end)
  end
end
