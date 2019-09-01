defmodule MagasinCore.Sales.PlacingAnOrderTest do
  use MagasinCore.TestCase

  alias MagasinCore.{Catalog, Email, Quantity}
  alias MagasinCore.Sales.{OrderApplicationService, OrderRepository, PlaceOrder}

  @moduletag timeout: 1_000

  describe "given valid command" do
    test "an order placed" do
      order_id = OrderRepository.next_id()
      product_id = Catalog.ProductRepository.next_id()

      command =
        PlaceOrder.new!(%{
          "order_id" => to_string(order_id),
          "email" => "foo@bar.com",
          "product_id" => to_string(product_id),
          "quantity" => "1",
          "line_items" => [],
          "shipping_address" => %{
            "street_address" => "1 Main St",
            "city" => "Montreal",
            "postal_code" => "H2T1S6"
          }
        })

      _result = OrderApplicationService.handle(command)

      {:ok, placed_order} = OrderRepository.get(order_id)
      assert placed_order
      assert placed_order.id == order_id
      assert placed_order.product_id == product_id
      assert placed_order.email == Email.new!("foo@bar.com")
      assert placed_order.quantity == Quantity.new!(1)
    end
  end

  describe "given duplicate keys" do
    test "returns an error" do
      order_id = OrderRepository.next_id()
      product_id = Catalog.ProductRepository.next_id()

      command =
        PlaceOrder.new!(%{
          "order_id" => to_string(order_id),
          "email" => "foo@bar.com",
          "product_id" => to_string(product_id),
          "quantity" => "1",
          "line_items" => [],
          "shipping_address" => %{
            "street_address" => "1 Main St",
            "city" => "Montreal",
            "postal_code" => "H2T1S6"
          }
        })

      OrderApplicationService.handle(command)
      result = OrderApplicationService.handle(command)

      assert {:error, _} = result
    end
  end
end
