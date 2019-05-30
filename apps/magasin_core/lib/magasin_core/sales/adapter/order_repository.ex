defmodule MagasinCore.Sales.OrderRepository do
  @moduledoc """
  A collection of order aggregates.
  """

  use CivilCode.Repository, repo: MagasinData.Repo

  alias MagasinCore.Sales.Order
  alias MagasinData.Sales.{OrderId, OrderRecord}

  @impl true
  def next_id do
    OrderId.new!(UUID.uuid4())
  end

  @impl true
  def get(order_id) do
    OrderRecord
    |> Repo.lock()
    |> Repo.get!(order_id)
    |> load(Order)
  end

  @impl true
  def save(struct_or_changeset) do
    fields =
      struct_or_changeset
      |> Ecto.Changeset.change()
      |> Ecto.Changeset.apply_changes()
      |> Map.take([:id, :email, :product_id, :quantity])

    result =
      %OrderRecord{}
      |> Ecto.Changeset.change(fields)
      |> Ecto.Changeset.unique_constraint(:id, name: :magasin_sale_orders_pkey)
      |> Repo.insert_or_update()

    case result do
      {:ok, record} -> Result.ok(record.id)
      {:error, changeset} -> changeset |> RepositoryError.validate() |> Repo.rollback()
    end
  end
end
