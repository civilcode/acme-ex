defmodule Magasin.Sales.Order do
  @moduledoc false

  use CivilCode.Aggregate

  alias Magasin.{Catalog, Email, Quantity}
  alias Magasin.Sales.{OrderId, OrderPlaced}

  typedstruct do
    field :id, OrderId.t()
    field :email, Email.t()
    field :product_id, Catalog.ProductId.t()
    field :quantity, Quantity.t()

    field :__entity__, CivilCode.Entity.Metadata.t()
  end

  @type place_params :: %{
          order_id: OrderId.t(),
          email: Email.t(),
          product_id: Catalog.ProductId.t(),
          quantity: Quantity.t()
        }

  @spec place(place_params) :: {:ok, t}
  def place(params) do
    apply_event(new_aggregrate_root(), fn _state ->
      struct(OrderPlaced, params)
    end)
  end

  defp new_aggregrate_root do
    CivilCode.Entity.new(__MODULE__)
  end

  @doc false
  @spec apply(t, OrderPlaced.t()) :: t
  def apply(struct, %OrderPlaced{} = event) do
    CivilCode.Entity.put_changes(
      struct,
      id: event.order_id,
      email: event.email,
      product_id: event.product_id,
      quantity: event.quantity
    )
  end
end
