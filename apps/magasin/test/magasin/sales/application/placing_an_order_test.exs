defmodule Magasin.Sales.Application.PlacingAnOrderTest do
  use Magasin.TestCase
  alias Magasin.Sales.Application.{OrderApplicationService, PlaceOrder}
  alias Magasin.Sales.Domain.Order

  test "an order placed" do
    order_guid = UUID.uuid4()
    command = %PlaceOrder{guid: order_guid, email: "foo@bar.com"}

    _result = OrderApplicationService.handle(command)

    placed_order = Repo.get(Order, order_guid)
    assert placed_order
  end
end
