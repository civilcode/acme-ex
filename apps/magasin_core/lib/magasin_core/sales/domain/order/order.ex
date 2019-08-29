defmodule MagasinCore.Sales.Order do
  @moduledoc """
  The order Entity.
  """

  use CivilCode.AggregateRoot

  alias MagasinCore.Sales.OrderPlaced
  alias MagasinData.{Catalog, Email, Quantity}
  alias MagasinData.Sales.OrderId

  schema do
    field :id, OrderId.t()
    field :email, Email.t()
    field :product_id, Catalog.ProductId.t()
    field :quantity, Quantity.t()
  end

  @spec place(OrderId.t(), Email.t(), Catalog.ProductId.t(), Quantity.t()) ::
          {:ok, Ecto.Changeset.t(t)}
  def place(order_id, email, product_id, quantity) do
    fields = [
      order_id: order_id,
      email: email,
      product_id: product_id,
      quantity: quantity
    ]

    fields
    |> OrderPlaced.new()
    |> apply_event
    |> Result.ok()
  end

  defp apply_event(_state \\ nil, %OrderPlaced{} = event) do
    event
    |> Map.take([:email, :product_id, :quantity])
    |> Map.put(:id, event.order_id)
    |> new
    |> put_event(event)
  end
end
