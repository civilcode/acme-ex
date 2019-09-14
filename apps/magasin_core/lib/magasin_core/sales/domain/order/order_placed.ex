defmodule MagasinCore.Sales.OrderPlaced do
  @moduledoc """
  A domain event representing the fact when a order has been placed.
  """

  use CivilCode.DomainEvent

  alias MagasinCore.Sales.OrderId
  alias MagasinCore.{Catalog, Email, Quantity}

  typedstruct do
    field :order_id, OrderId.t()
    field :email, Email.t()
    field :product_id, Catalog.ProductId.t()
    field :quantity, Quantity.t()
  end
end
