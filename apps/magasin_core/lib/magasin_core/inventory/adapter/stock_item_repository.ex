defmodule MagasinCore.Inventory.StockItemRepository do
  @moduledoc """
  A collection of stock item aggregates.
  """

  use CivilCode.Repository, repo: MagasinData.Repo

  alias MagasinCore.Inventory.StockItem
  alias MagasinData.Inventory.{StockItemId, StockItemRecord}

  @impl true
  def next_id do
    StockItemId.new!(UUID.uuid4())
  end

  @impl true
  def get(stock_item_id) do
    StockItemRecord
    |> Repo.lock()
    |> Repo.get(stock_item_id)
    |> load(StockItem)
  end

  def get_by_product_id(product_id) do
    StockItemRecord
    |> Repo.lock()
    |> Repo.get_by(product_id: product_id.value)
    |> load(StockItem)
  end

  @impl true
  def save(changeset) do
    stock_item = Ecto.Changeset.apply_changes(changeset)
    fields = Map.take(stock_item, [:id, :count_on_hand])

    result =
      stock_item
      |> get_record()
      |> Ecto.Changeset.change(fields)
      |> Repo.insert_or_update()

    case result do
      {:ok, record} -> Result.ok(record.id)
      {:error, changeset} -> changeset |> RepositoryError.validate() |> Repo.rollback()
    end
  end
end
