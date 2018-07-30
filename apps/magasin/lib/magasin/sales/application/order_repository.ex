defmodule Magasin.Sales.Application.OrderRepository do
  @moduledoc false

  use CivilCode.Repository

  alias Magasin.Repo
  alias Magasin.Sales.Domain.Order

  def add(order) do
    order.state
    |> Ecto.Changeset.unique_constraint(:id, name: :magasin_sale_orders_pkey)
    |> Repo.insert()
  end

  def get(order_id) do
    build(Order, fn ->
      Repo.get(Order.State, order_id)
    end)
  end
end
