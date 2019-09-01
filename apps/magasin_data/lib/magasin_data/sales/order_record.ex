defmodule MagasinData.Sales.OrderRecord do
  @moduledoc false
  use CivilCode.Record

  @primary_key {:id, :binary_id, autogenerate: false}

  schema "magasin_sale_orders" do
    field :email, :string
    field :product_id, :binary_id
    field :quantity, :integer

    timestamps()
  end
end
