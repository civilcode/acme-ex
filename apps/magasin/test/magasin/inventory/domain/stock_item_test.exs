defmodule Magasin.Inventory.StockItemTest do
  use Magasin.TestCase

  alias Magasin.Inventory.{OutOfStock, StockItem}
  alias Magasin.Quantity

  describe "deplenishing a stock item in stock" do
    test "decreases the count on hand by the given quantity" do
      stock_item = StockItem.new(count_on_hand: Quantity.new!(2))
      quantity = Quantity.new!(1)

      {:ok, deplinished_stock_item} = StockItem.deplenish(stock_item, quantity)

      new_state = CivilCode.Entity.get_state(deplinished_stock_item)

      assert new_state.count_on_hand == quantity
    end
  end

  describe "deplenishing an out of stock item" do
    test "does not decrease the count on hand" do
      count_on_hand = Quantity.new!(0)
      stock_item = StockItem.new(count_on_hand: count_on_hand)
      quantity = Quantity.new!(1)

      {:error, business_rule_violation} = StockItem.deplenish(stock_item, quantity)

      %{entity: untouched_stock_item} = business_rule_violation
      new_state = CivilCode.Entity.get_state(untouched_stock_item)
      assert new_state.count_on_hand == count_on_hand
    end

    test "notifies the item is out of stock" do
      count_on_hand = Quantity.new!(0)
      stock_item = StockItem.new(count_on_hand: count_on_hand)
      quantity = Quantity.new!(1)

      result = StockItem.deplenish(stock_item, quantity)

      assert {:error, %{type: %OutOfStock{}}} = result
    end
  end
end
