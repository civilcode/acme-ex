defmodule MagasinCore.Sales.Order do
  @moduledoc """
  The order Entity.
  """

  use CivilCode.Aggregate.Root

  alias MagasinCore.Sales.OrderPlaced
  alias MagasinData.{Catalog, Email, Quantity}
  alias MagasinData.Sales.OrderId

  embedded_schema do
    field :id, OrderId
    field :email, Email
    field :product_id, Catalog.ProductId
    field :quantity, Quantity
  end

  @spec place(OrderId.t(), Email.t(), Catalog.ProductId.t(), Quantity.t()) ::
          {:ok, Ecto.Changeset.t(t)}
  def place(order_id, email, product_id, quantity) do
    fields = [
      id: order_id,
      email: email,
      product_id: product_id,
      quantity: quantity
    ]

    order_placed = OrderPlaced.new(fields)

    new()
    |> change(order_placed, fields)
    |> Result.ok()
  end
end
