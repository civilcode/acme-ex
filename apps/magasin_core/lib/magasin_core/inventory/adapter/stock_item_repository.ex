defmodule MagasinCore.Inventory.StockItemRepository do
  @moduledoc """
  A collection of stock item aggregates.
  """

  use CivilCode.Repository, repo: MagasinData.Repo

  alias MagasinCore.Inventory.StockItem
  alias MagasinData.Catalog
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

  @spec get_by_product_id(Catalog.ProductId.t()) :: Result.t(StockItem.t())
  def get_by_product_id(product_id) do
    StockItemRecord
    |> Repo.lock()
    |> Repo.get_by(product_id: product_id.value)
    |> load(StockItem)
  end

  @impl true
  def save(stock_item) do
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
