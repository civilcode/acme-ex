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
  def save(struct_or_changeset) do
    fields =
      struct_or_changeset
      |> Ecto.Changeset.change()
      |> Ecto.Changeset.apply_changes()
      |> Map.take([:id, :email, :product_id, :quantity])

    result =
      %Record{}
      |> Ecto.Changeset.change(fields)
      |> Ecto.Changeset.unique_constraint(:id, name: :magasin_sale_orders_pkey)
      |> Repo.insert_or_update()

    case result do
      {:ok, record} -> Result.ok(record.id)
      {:error, changeset} -> RepositoryError.validate(changeset)
    end
  end
end
