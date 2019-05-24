defmodule MagasinCore.Sales.Order do
  @moduledoc """
  The order Entity.
  """

  use CivilCode.Aggregate.Root

  alias MagasinCore.Sales.OrderPlaced
  alias MagasinData.{Catalog, Email, Quantity}
  alias MagasinData.Sales.OrderId

  entity_schema do
    field :id, OrderId.t()
    field :email, Email.t()
    field :product_id, Catalog.ProductId.t()
    field :quantity, Quantity.t()
  end

  # Public API

  @spec place(%{
          order_id: OrderId.t(),
          email: Email.t(),
          product_id: Catalog.ProductId.t(),
          quantity: Quantity.t()
        }) :: {:ok, t}
  def place(params) do
    update(entity(__MODULE__), fn _state -> OrderPlaced.new(params) end)
  end

  # State mutators

  @doc false
  @spec apply(t, OrderPlaced.t()) :: t
  def apply(entity, %OrderPlaced{} = event) do
    put_changes(entity,
      id: event.order_id,
      email: event.email,
      product_id: event.product_id,
      quantity: event.quantity
    )
  end
end
