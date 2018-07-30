defmodule Magasin.Sales.Domain.OrderTest do
  use Magasin.TestCase

  alias Magasin.Catalog.Domain, as: Catalog
  alias Magasin.{Email, Quantity}
  alias Magasin.Sales.Domain.{Order, OrderId}

  describe "placing an order" do
    test "order is placed" do
      product_id = Catalog.ProductId.new!()
      order_id = OrderId.new!()
      quantity = Quantity.new!(1)
      email = Email.new!("foo@bar.com")

      {:ok, placed_order} =
        Order.place(%{
          order_id: order_id,
          email: email,
          product_id: product_id,
          quantity: quantity
        })

      new_state = CivilCode.Entity.get_state(placed_order)

      assert new_state.id == order_id
      assert new_state.email == email
      assert new_state.product_id == product_id
      assert new_state.quantity == quantity
    end
  end
end
