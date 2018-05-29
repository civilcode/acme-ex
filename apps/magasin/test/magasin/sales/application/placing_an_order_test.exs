defmodule Magasin.Sales.Application.PlacingAnOrderTest do
  use Magasin.TestCase
  alias Magasin.Sales.Application.{OrderApplicationService, PlaceOrder, OrderRepository}
  alias Magasin.Sales.Domain.Order

  describe "given valid command" do
    test "an order placed" do
      order_guid = UUID.uuid4()
      command = %PlaceOrder{guid: order_guid, email: "foo@bar.com"}

      _result = OrderApplicationService.handle(command)

      placed_order = OrderRepository.get(order_guid)
      assert placed_order
    end
  end

  describe "given invalid command" do
    test "returns an error" do
      order_guid = UUID.uuid4()
      command = %PlaceOrder{guid: order_guid, email: nil}

      result = OrderApplicationService.handle(command)

      assert {:error, _} = result
    end
  end

  describe "given duplicate keys" do
    test "returns an error" do
      order_guid = UUID.uuid4()
      command = %PlaceOrder{guid: order_guid, email: "foo@bar.com"}

      OrderApplicationService.handle(command)
      result = OrderApplicationService.handle(command)

      assert {:error, _} = result
    end
  end
end
