defmodule Magasin.Sales.Application.PlaceOrderTest do
  use Magasin.TestCase

  alias CivilCode.ValidationError
  alias Magasin.Catalog.Domain, as: Catalog
  alias Magasin.{Email, Quantity}
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
        quantity: 1
      }

      {:ok, domain_values} = PlaceOrder.to_domain(command)

      assert domain_values.order_id == order_id
      assert domain_values.email == Email.new!("foo@bar.com")
      assert domain_values.product_id == product_id
      assert domain_values.quantity == Quantity.new!(1)
    end

    test "invalid command returns validation error" do
      order_id = OrderId.new!()
      product_id = Catalog.ProductId.new!()

      command = %PlaceOrder{
        order_id: order_id.value,
        email: nil,
        product_id: product_id.value,
        quantity: nil
      }

      {:error, validation_error} = PlaceOrder.to_domain(command)

      assert %ValidationError{} = validation_error
      assert validation_error.data == command
      assert {:email, "is required"} in validation_error.errors
      assert {:quantity, "is required"} in validation_error.errors
    end
  end
end
