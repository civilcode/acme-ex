defmodule Magasin.Sales.Domain.Order do
  @moduledoc false

  use CivilCode.Aggregate

  alias Magasin.{Email, Quantity}
  alias Magasin.Catalog.Domain, as: Catalog
  alias Magasin.Sales.Domain.{OrderId, OrderPlaced}

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
end
