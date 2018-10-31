defmodule Magasin.Sales.Application.OrderRepository do
  @moduledoc false

  use CivilCode.Repository

  alias CivilCode.RepositoryError
  alias Magasin.Repo
  alias Magasin.Sales.Domain.Order

  def add(order) do
    result =
      order.state
      |> Ecto.Changeset.change()
      |> Ecto.Changeset.unique_constraint(:id, name: :magasin_sale_orders_pkey)
      |> Repo.insert()

    case result do
      {:ok, order_state} -> Result.ok(order_state.id)
      {:error, changeset} -> RepositoryError.validate(changeset)
    end
  end

  def get(order_id) do
    build(Order, fn ->
      Repo.get(Order.State, order_id)
    end)
  end
end
