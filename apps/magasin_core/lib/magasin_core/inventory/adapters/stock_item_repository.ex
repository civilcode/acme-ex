defmodule MagasinCore.Inventory.StockItemRepository do
  @moduledoc """
  A collection of stock item aggregates.
  """

  use CivilCode.Repository, repo: MagasinData.Repo

  alias MagasinCore.{Catalog, Quantity}

  alias MagasinCore.Inventory.{StockItem, StockItemId}
  alias MagasinData.Inventory.StockItemRecord

  @impl true
  def next_id do
    StockItemId.new!(UUID.uuid4())
  end

  @impl true
  def get(stock_item_id) do
    StockItemRecord
    |> Repo.lock()
    |> Repo.get(stock_item_id.value)
    |> load_aggregate(StockItem)
  end

  @spec get_by_product_id(Catalog.ProductId.t()) :: Result.ok(StockItem.t())
  def get_by_product_id(product_id) do
    StockItemRecord
    |> Repo.lock()
    |> Repo.get_by(product_id: product_id.value)
    |> load_aggregate(StockItem)
  end

  defp load_aggregate(record, aggregate) do
    schema = %{id: StockItemId, count_on_hand: Quantity}
    keys = Map.keys(schema)
    params = Map.take(record, keys)

    {struct(aggregate), schema}
    |> Ecto.Changeset.cast(params, keys)
    |> Ecto.Changeset.apply_changes()
    |> Result.ok()
  end

  @impl true
  def save(stock_item) do
    fields = [
      id: stock_item.id.value,
      count_on_hand: stock_item.count_on_hand.value
    ]

    result =
      StockItemRecord
      |> Repo.get!(stock_item.id.value)
      |> Ecto.Changeset.change(fields)
      |> Repo.insert_or_update()

    case result do
      {:ok, record} -> Result.ok(record.id)
      {:error, changeset} -> changeset |> RepositoryError.validate() |> Repo.rollback()
    end
  end
end
