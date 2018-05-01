defmodule Magasin.Inventory.Application.OrderPlacedTest do
  use Magasin.TestCase

  alias Magasin.Sales.Domain.OrderPlaced
  alias Magasin.Inventory.Application.StockItemApplicationService
  alias Magasin.Inventory.Domain.StockItem

  describe "given an order placed event received" do
    test "the count on hand is decreased" do
      product_guid = UUID.uuid4()

      previous_stock_item =
        Repo.insert(%StockItem.State{count_on_hand: 1, product_id: product_guid})

      event = %OrderPlaced{product_guid: product_guid, quantity: 1}

      _result = StockItemApplicationService.handle(event)

      current_stock_item = InventoryRepository.get(previous_stock_item.id)
      assert current_stock_item.count_on_hand == 0
    end
  end
end
