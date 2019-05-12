defmodule Magasin.Inventory.Application.StockItemRepository do
  @moduledoc false

  use CivilCode.Repository

  alias Magasin.Inventory.Domain.StockItem
  alias Magasin.Repo

  defmodule Schema do
    @moduledoc false
    use Magasin.Schema
    alias Magasin.Inventory.Domain.StockItemId
    alias Magasin.Quantity

    @primary_key {:id, StockItemId.Ecto.Type, autogenerate: false}

    schema "magasin_inventory_stock_items" do
      field :count_on_hand, Quantity.Ecto.Type
      field :product_id, :binary_id

      field :__entity__, :string, virtual: true

      timestamps()
    end
  end

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

  def update(entity) do
    build(StockItem, fn ->
      entity
      |> Entity.get_assigns(:record)
      |> Ecto.Changeset.change(Entity.get_fields(entity, [:count_on_hand]))
      |> Repo.update!()
    end)
  end
end
