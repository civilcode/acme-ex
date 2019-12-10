defmodule MagasinCore.Sales.OrderRepository do
  @moduledoc """
  A collection of order aggregates.
  """

  use CivilCode.Repository, repo: MagasinData.Repo

  alias MagasinCore.{Catalog, Email, Quantity}
  alias MagasinCore.Sales.{Order, OrderId}
  alias MagasinData.Sales.{OrderRecord}

  @impl true
  def next_id do
    OrderId.new!(UUID.uuid4())
  end

  @impl true
  def get(order_id) do
    OrderRecord
    |> Repo.lock()
    |> Repo.get!(order_id.value)
    |> load_aggregate(Order)
  end

  defp load_aggregate(record, aggregate) do
    schema = %{id: OrderId, email: Email, product_id: Catalog.ProductId, quantity: Quantity}
    keys = Map.keys(schema)
    params = Map.take(record, keys)

    {struct(aggregate), schema}
    |> Ecto.Changeset.cast(params, keys)
    |> Ecto.Changeset.apply_changes()
    |> Result.ok()
  end

  @impl true
  def save(struct) do
    fields = [
      id: struct.id.value,
      email: struct.email.value,
      product_id: struct.product_id.value,
      quantity: struct.quantity.value
    ]

    result =
      %OrderRecord{}
      |> Ecto.Changeset.change(fields)
      |> Ecto.Changeset.unique_constraint(:id, name: :magasin_sale_orders_pkey)
      |> Repo.insert_or_update()

    case result do
      {:ok, _record} ->
        for event <- fetch_events(struct) do
          CivilBus.publish(:domain_events, event)
        end

        Result.ok(struct.id)

      {:error, changeset} ->
        changeset |> RepositoryError.validate() |> Repo.rollback()
    end
  end

  defp fetch_events(struct) do
    struct.__civilcode__.events
  end
end
