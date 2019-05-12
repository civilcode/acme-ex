defmodule Magasin.Inventory.StockItemRepository do
  @moduledoc false

  use CivilCode.Repository

  alias CivilCode.RepositoryError
  alias Magasin.Inventory.{StockItem, StockItemId}
  alias Magasin.Repo

  defmodule Schema do
    @moduledoc false
    use Magasin.Schema

    alias Magasin.Inventory.StockItemId
    alias Magasin.Quantity

    @primary_key {:id, StockItemId.Ecto.Type, autogenerate: false}

    schema "magasin_inventory_stock_items" do
      field :count_on_hand, Quantity.Ecto.Type
      field :product_id, :binary_id

      field :__entity__, :string, virtual: true

      timestamps()
    end
  end

  @impl true
  def next_id do
    StockItemId.new!(UUID.uuid4())
  end

  @impl true
  def get(stock_item_id) do
    build(StockItem, fn ->
      Repo.get(Schema, stock_item_id)
    end)
  end

  def get_by_product_id(product_id) do
    build(StockItem, fn ->
      Repo.get_by(Schema, product_id: product_id.value)
    end)
  end

  @impl true
  def save(entity) do
    result =
      entity.__entity__.assigns.record
      |> Ecto.Changeset.change(Entity.get_fields(entity, [:id, :count_on_hand]))
      |> Repo.insert_or_update()

    case result do
      {:ok, entity_state} -> Result.ok(entity_state.id)
      {:error, changeset} -> RepositoryError.validate(changeset)
    end
  end
end
