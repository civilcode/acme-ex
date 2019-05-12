defmodule Magasin.Sales.OrderPlaced do
  @moduledoc """
  A domain event representing the fact when a order has been placed.
  """

  use CivilCode.DomainEvent

  typedstruct enforce_keys: true do
    field :order_id, Magasin.Sales.OrderId.t()
    field :email, Magasin.Email.t()
    field :product_id, Magasin.Catalog.ProductId.t()
    field :quantity, Magasin.Email.t()
  end
end
