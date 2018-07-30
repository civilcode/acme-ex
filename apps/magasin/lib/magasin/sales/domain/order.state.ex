defmodule Magasin.Sales.Domain.Order.State do
  @moduledoc false

  use Magasin.Schema

  alias Magasin.Sales.Domain.{OrderId, OrderPlaced}
  alias Magasin.Catalog.Domain, as: Catalog
  alias Magasin.{Email, Quantity}

  @primary_key {:id, OrderId.Ecto.Type, autogenerate: false}

  schema "magasin_sale_orders" do
    field(:email, Email.Ecto.Type)
    field(:product_id, Catalog.ProductId.Ecto.Type)
    field(:quantity, Quantity.Ecto.Type)

    timestamps()
  end

  def apply(state, %OrderPlaced{} = event) do
    change(
      state,
      id: event.order_id,
      email: event.email,
      product_id: event.product_id,
      quantity: event.quantity
    )
  end
end
