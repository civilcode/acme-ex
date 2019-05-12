defmodule Magasin.Sales.PlacingAnOrderTest do
  use Magasin.TestCase

  alias Magasin.{Catalog, Email, Quantity}
  alias Magasin.Sales.{OrderApplicationService, OrderRepository, PlaceOrder}

  @moduletag timeout: 1_000

  describe "given valid command" do
    test "an order placed" do
      order_id = OrderRepository.next_id()
      product_id = Catalog.ProductRepository.next_id()

      command = %PlaceOrder{
        order_id: order_id.value,
        email: "foo@bar.com",
        product_id: product_id.value,
        quantity: 1,
        line_items: [],
        shipping_address: %{
          street_address: "1 Main St",
          city: "Montreal",
          postal_code: "H2T1S6"
        }
      }

      _result = OrderApplicationService.handle(command)

      placed_order = OrderRepository.get(order_id)
      state = CivilCode.Entity.get_state(placed_order)
      assert state
      assert state.id == order_id
      assert state.product_id == product_id
      assert state.email == Email.new!("foo@bar.com")
      assert state.quantity == Quantity.new!(1)
    end
  end

  describe "given invalid command" do
    test "returns an error" do
      order_id = OrderRepository.next_id()
      product_id = Catalog.ProductRepository.next_id()

      command = %PlaceOrder{
        order_id: order_id.value,
        email: nil,
        product_id: product_id.value,
        quantity: 1,
        line_items: [],
        shipping_address: %{
          street_address: "1 Main St",
          city: "Montreal"
        }
      }

      result = OrderApplicationService.handle(command)

      assert {:error, _} = result
    end
  end

  describe "given duplicate keys" do
    test "returns an error" do
      order_id = OrderRepository.next_id()
      product_id = Catalog.ProductRepository.next_id()

      command = %PlaceOrder{
        order_id: order_id.value,
        email: "foo@bar.com",
        product_id: product_id.value,
        quantity: 1,
        line_items: [],
        shipping_address: %{
          street_address: "1 Main St",
          city: "Montreal"
        }
      }

      OrderApplicationService.handle(command)
      result = OrderApplicationService.handle(command)

      assert {:error, _} = result
    end
  end
end
