defmodule Magasin.Sales.Domain.Order.State do
  @moduledoc false

  use Magasin.Schema

  alias Magasin.Sales.Domain.OrderPlaced

  schema "magasin_sale_orders" do
    field(:email, :string)

    timestamps()
  end

  def apply(state, %OrderPlaced{} = event) do
    change(state, id: event.guid, email: event.email)
  end
end
