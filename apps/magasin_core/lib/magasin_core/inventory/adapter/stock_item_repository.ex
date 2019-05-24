defmodule MagasinCore.Inventory.StockItemRepository do
  @moduledoc """
  A collection of stock item aggregates.
  """

  use CivilCode.Repository

  alias MagasinCore.Inventory.StockItem

  alias MagasinData.{Catalog, Repo}
  alias MagasinData.Inventory.StockItem, as: Record
  alias MagasinData.Inventory.StockItemId

  defdelegate transaction(fun, opts \\ []), to: Repo

  @impl true
  def next_id do
    StockItemId.new!(UUID.uuid4())
  end

  @impl true
  def get(stock_item_id) do
    build(StockItem, fn ->
      Repo.get(Record, stock_item_id)
    end)
  end

  @spec get_by_product_id(Catalog.ProductId.t()) :: StockItem.t()
  def get_by_product_id(product_id) do
    build(StockItem, fn ->
      Repo.get_by(Record, product_id: product_id.value)
    end)
  end

  @impl true
  def save(entity) do
    result =
      entity
      |> Entity.get_assigns(:record)
      |> Ecto.Changeset.change(Entity.get_fields(entity, [:id, :count_on_hand]))
      |> Repo.insert_or_update()

    case result do
      {:ok, entity_state} -> Result.ok(entity_state.id)
      {:error, changeset} -> RepositoryError.validate(changeset)
    end
  end
end
