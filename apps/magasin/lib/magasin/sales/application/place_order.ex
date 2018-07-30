defmodule Magasin.Sales.Application.PlaceOrder do
  @moduledoc false

  alias Magasin.Catalog.Domain, as: Catalog
  alias Magasin.{Email, Quantity}
  alias Magasin.Sales.Domain.OrderId

  use CivilCode.Command,
    schema: %{
      order_id: OrderId,
      email: Email,
      product_id: Catalog.ProductId,
      quantity: Quantity
    }

  @enforce_keys [:order_id, :email, :product_id, :quantity]
  defstruct [:order_id, :email, :product_id, :quantity]
end
