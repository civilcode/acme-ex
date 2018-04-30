defmodule Magasin.Repo.Migrations.CreateSaleOrders do
  use Ecto.Migration

  def change do
    create table(:magasin_sale_orders, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:email, :string, null: false)

      timestamps()
    end
  end
end
