defmodule Magasin.Inventory.Application.StockItemRepository do
  @moduledoc false

  use CivilCode.Repository

  alias Magasin.Inventory.Domain.StockItem
  alias Magasin.Repo

  def get(stock_item_id) do
    build(StockItem, fn ->
      Repo.get(StockItem.State, stock_item_id)
    end)
  end

  def get_by_product_id(product_id) do
    build(StockItem, fn ->
      Repo.get_by(StockItem.State, product_id: product_id.value)
    end)
  end

  def update(entity) do
    build(StockItem, fn ->
      entity
      |> Entity.get_changes()
      |> Repo.update!()
    end)
  end
end
