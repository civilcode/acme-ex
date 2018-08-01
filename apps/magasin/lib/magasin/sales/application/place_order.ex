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
      shipping_address: Address,
      line_items: [%{product_id: Catalog.ProductId, quantity: Quantity}]
    }

  @enforce_keys [:order_id, :email, :product_id, :quantity, :shipping_address, :line_items]
  defstruct [:order_id, :email, :product_id, :quantity, :shipping_address, :line_items]
end
