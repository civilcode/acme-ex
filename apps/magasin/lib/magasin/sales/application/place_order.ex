defmodule Magasin.Sales.Application.PlaceOrder do
  @moduledoc false

  alias Magasin.Catalog.Domain, as: Catalog
  alias Magasin.{Address, Email, Quantity}
  alias Magasin.Sales.Domain.OrderId

  use CivilCode.Command,
    schema: %{
      order_id: OrderId,
      email: Email,
      product_id: Catalog.ProductId,
      quantity: Quantity,
      shipping_address: Address
    }

  @enforce_keys [:order_id, :email, :product_id, :quantity, :shipping_address]
  defstruct [:order_id, :email, :product_id, :quantity, :shipping_address]
end
