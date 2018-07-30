defmodule Magasin.Sales.Domain.OrderPlaced do
  @moduledoc false

  use CivilCode.DomainEvent

  @enforce_keys [:order_id, :email, :product_id, :quantity]
  defstruct [:order_id, :email, :product_id, :quantity]

  @type t :: %__MODULE__{
          order_id: Magasin.Sales.Domain.OrderId.t(),
          email: Magasin.Email.t(),
          product_id: Magasin.Catalog.Domain.ProductId.t(),
          quantity: Magasin.Email.t()
        }
end
