defmodule MagasinCore.Inventory.StockItemTest do
  use MagasinCore.TestCase

  alias MagasinCore.Inventory.{OutOfStock, StockItem}
  alias MagasinData.Quantity

  describe "deplenishing a stock item in stock" do
    test "decreases the count on hand by the given quantity" do
      stock_item = StockItem.new(count_on_hand: Quantity.new!(2))
      quantity = Quantity.new!(1)

      deplinished_stock_item =
        stock_item
        |> StockItem.deplenish(quantity)
        |> apply_changes

      assert deplinished_stock_item.count_on_hand == quantity
    end
  end

  describe "deplenishing an out of stock item" do
    test "does not decrease the count on hand" do
      count_on_hand = Quantity.new!(0)
      stock_item = StockItem.new(count_on_hand: count_on_hand)
      quantity = Quantity.new!(1)

      {:error, business_rule_violation} = StockItem.deplenish(stock_item, quantity)

      %{entity: untouched_stock_item} = business_rule_violation
      assert untouched_stock_item.count_on_hand == count_on_hand
    end

    test "notifies the item is out of stock" do
      count_on_hand = Quantity.new!(0)
      stock_item = StockItem.new(count_on_hand: count_on_hand)
      quantity = Quantity.new!(1)

      result = StockItem.deplenish(stock_item, quantity)

      assert {:error, %OutOfStock{}} = result
    end
  end
end
