defmodule Magasin.Sales.Application.PlacingAnOrderTest do
  use Magasin.TestCase
  alias Magasin.{Email, Quantity}
  alias Magasin.Sales.Application.{OrderApplicationService, OrderRepository, PlaceOrder}
  alias Magasin.Sales.Domain.OrderId
  alias Magasin.Catalog.Domain, as: Catalog

  describe "given valid command" do
    test "an order placed" do
      order_id = OrderId.new!()
      product_id = Catalog.ProductId.new!()

      command = %PlaceOrder{
        order_id: order_id.value,
        email: "foo@bar.com",
        product_id: product_id.value,
        quantity: 1
      }

      _result = OrderApplicationService.handle(command)

      placed_order = OrderRepository.get(order_id)
      state = CivilCode.Entity.get_state(placed_order)
      assert state.id == order_id
      assert state.product_id == product_id
      assert state.email == Email.new!("foo@bar.com")
      assert state.quantity == Quantity.new!(1)
    end
  end

  describe "given invalid command" do
    test "returns an error" do
      order_id = OrderId.new!()
      product_id = Catalog.ProductId.new!()

      command = %PlaceOrder{
        order_id: order_id.value,
        email: nil,
        product_id: product_id.value,
        quantity: 1
      }

      result = OrderApplicationService.handle(command)

      assert {:error, _} = result
    end
  end

  describe "given duplicate keys" do
    test "returns an error" do
      order_id = OrderId.new!()
      product_id = Catalog.ProductId.new!()

      command = %PlaceOrder{
        order_id: order_id.value,
        email: "foo@bar.com",
        product_id: product_id.value,
        quantity: 1
      }

      OrderApplicationService.handle(command)
      result = OrderApplicationService.handle(command)

      assert {:error, _} = result
    end
  end
end
