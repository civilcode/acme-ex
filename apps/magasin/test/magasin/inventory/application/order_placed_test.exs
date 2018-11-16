defmodule Magasin.Inventory.Application.OrderPlacedTest do
  use Magasin.TestCase

  alias Magasin.Catalog.Domain, as: Catalog
  alias Magasin.{Email, Quantity}
  alias Magasin.Sales.Domain.{OrderId, OrderPlaced}

  alias Magasin.Inventory.Application.{StockItemApplicationService, StockItemRepository}
  alias Magasin.Inventory.Domain.{StockItem, StockItemId}

  @moduletag timeout: 1_000

  setup do
    order_id = OrderId.new!()
    product_id = Catalog.ProductId.new!()
    email = Email.new!("foo@bar.com")
    quantity = Quantity.new!(1)

    order_placed_event = %OrderPlaced{
      order_id: order_id,
      email: email,
      product_id: product_id,
      quantity: quantity
    }

    [order_placed_event: order_placed_event]
  end

  describe "a product in stock" do
    test "decreases the count on hand", %{order_placed_event: order_placed_event} do
      previous_stock_item =
        Repo.insert!(%StockItem.State{
          id: StockItemId.new!(),
          count_on_hand: Quantity.new!(1),
          product_id: order_placed_event.product_id.value
        })

      _result = StockItemApplicationService.handle(order_placed_event)

      current_stock_item = StockItemRepository.get(previous_stock_item.id)
      state = CivilCode.Entity.get_state(current_stock_item)
      assert state.count_on_hand == Quantity.new!(0)
    end
  end

  describe "a product out of stock" do
    test "notifies the product is out of stock", %{order_placed_event: order_placed_event} do
      previous_stock_item =
        Repo.insert!(%StockItem.State{
          id: StockItemId.new!(),
          count_on_hand: Quantity.new!(1),
          product_id: order_placed_event.product_id.value
        })

      _result = StockItemApplicationService.handle(order_placed_event)

      current_stock_item = StockItemRepository.get(previous_stock_item.id)
      state = CivilCode.Entity.get_state(current_stock_item)
      assert state.count_on_hand == Quantity.new!(0)
    end
  end
end
