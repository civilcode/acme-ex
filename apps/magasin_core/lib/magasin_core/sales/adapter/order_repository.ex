defmodule MagasinCore.Sales.OrderRepository do
  @moduledoc """
  A collection of order aggregates.
  """

  use CivilCode.Repository

  alias MagasinCore.Sales.Order

  alias MagasinData.Repo
  alias MagasinData.Sales.Order, as: Record
  alias MagasinData.Sales.OrderId

  defdelegate transaction(fun, opts \\ []), to: Repo

  @impl true
  def next_id do
    OrderId.new!(UUID.uuid4())
  end

  @impl true
  def get(order_id) do
    build(Order, fn ->
      Repo.get!(Record, order_id)
    end)
  end

  @impl true
  def save(order) do
    result =
      %Record{}
      |> Ecto.Changeset.change(Entity.get_fields(order, [:id, :email, :product_id, :quantity]))
      |> Ecto.Changeset.unique_constraint(:id, name: :magasin_sale_orders_pkey)
      |> Repo.insert_or_update()

    case result do
      {:ok, order_state} -> Result.ok(order_state.id)
      {:error, changeset} -> RepositoryError.validate(changeset)
    end
  end
end
