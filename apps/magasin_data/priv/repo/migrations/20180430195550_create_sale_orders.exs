defmodule MagasinData.Repo.Migrations.CreateSaleOrders do
  use Ecto.Migration

  def change do
    create table(:magasin_sale_orders) do
      add(:email, :string, null: false)
      add(:product_id, :binary_id, null: false)
      add(:quantity, :integer, null: false)

      timestamps()
    end
  end
end
