defmodule MagasinCore.Sales.PlaceOrderTest do
  use MagasinCore.TestCase

  alias MagasinCore.Catalog
  alias MagasinCore.Sales.{OrderRepository, PlaceOrder}
  alias MagasinData.{Address, Email, PostalCode, Quantity}

  describe "constructing a command" do
    test "valid params returns new command" do
      order_id = OrderRepository.next_id()
      product_id = Catalog.ProductRepository.next_id()

      {:ok, command} =
        PlaceOrder.new(
          order_id: order_id.value,
          email: "foo@bar.com",
          product_id: product_id.value,
          quantity: 1,
          line_items: [%{product_id: product_id.value, quantity: 1}],
          shipping_address: %{
            street_address: "1 Main St",
            city: "Montreal",
            postal_code: "H2T1S6"
          }
        )

      assert command.order_id == order_id
      assert command.email == Email.new!("foo@bar.com")
      assert command.product_id == product_id
      assert command.quantity == Quantity.new!(1)

      assert command.shipping_address ==
               command.shipping_address |> Map.from_struct() |> Address.new!()

      assert command.shipping_address.postal_code == PostalCode.new!("H2T1S6")

      assert line_item = List.first(command.line_items)
      assert line_item.quantity == Quantity.new!(1)
      assert line_item.product_id == product_id
    end

    test "invalid command returns invalid changeset" do
      order_id = OrderRepository.next_id()
      product_id = Catalog.ProductRepository.next_id()

      {:error, invalid_changeset} =
        PlaceOrder.new(
          order_id: order_id.value,
          email: nil,
          product_id: product_id.value,
          quantity: -1,
          line_items: nil,
          shipping_address: %{postal_code: ":invalid:"}
        )

      refute invalid_changeset.valid?
      assert "can't be blank" in errors_on(invalid_changeset).email
      assert "must be negative" in errors_on(invalid_changeset).quantity
      assert "can't be blank" in errors_on(invalid_changeset).shipping_address.city
      assert "is invalid" in errors_on(invalid_changeset).shipping_address.postal_code
    end
  end
end
