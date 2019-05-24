defmodule MagasinCore.Sales.OrderPlaced do
  @moduledoc """
  A domain event representing the fact when a order has been placed.
  """

  use CivilCode.DomainEvent

  typedstruct do
    field :order_id, MagasinData.Sales.OrderId.t()
    field :email, MagasinData.Email.t()
    field :product_id, MagasinData.Catalog.ProductId.t()
    field :quantity, MagasinData.Quantity.t()
  end
end
