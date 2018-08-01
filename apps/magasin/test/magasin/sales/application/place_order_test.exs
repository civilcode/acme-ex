defmodule Magasin.Sales.Application.PlaceOrderTest do
  use Magasin.TestCase

  alias CivilCode.Validation
  alias Magasin.Catalog.Domain, as: Catalog
  alias Magasin.{Address, Email, PostalCode, Quantity}
  alias Magasin.Sales.Application.PlaceOrder
  alias Magasin.Sales.Domain.OrderId

  describe "to_domain" do
    test "valid command returns domain values" do
      order_id = OrderId.new!()
      product_id = Catalog.ProductId.new!()

      command = %PlaceOrder{
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
      }

      {:ok, domain_values} = PlaceOrder.to_domain(command)

      assert domain_values.order_id == order_id
      assert domain_values.email == Email.new!("foo@bar.com")
      assert domain_values.product_id == product_id
      assert domain_values.quantity == Quantity.new!(1)
      assert domain_values.shipping_address == Address.new!("1 Main St", "Montreal", "H2T1S6")
      assert domain_values.shipping_address.postal_code == PostalCode.new!("H2T1S6")
      assert domain_values.line_items
      assert domain_values.line_items == [%{product_id: product_id, quantity: Quantity.new!(1)}]
    end

    test "invalid command returns validation error" do
      order_id = OrderId.new!()
      product_id = Catalog.ProductId.new!()

      command = %PlaceOrder{
        order_id: order_id.value,
        email: nil,
        product_id: product_id.value,
        quantity: nil,
        line_items: nil,
        shipping_address: %{}
      }

      {:error, validation_error} = PlaceOrder.to_domain(command)

      assert %Validation{} = validation_error
      assert validation_error.data == command
      assert {:email, "is required"} in validation_error.errors
      assert {:quantity, "is required"} in validation_error.errors
      assert {:postal_code, "is required"} in validation_error.errors[:shipping_address]
    end
  end
end
