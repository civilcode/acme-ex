defmodule MagasinData.Sales.OrderRecord do
  @moduledoc false
  use CivilCode.Record

  alias MagasinData.{Catalog, Email, Quantity}
  alias MagasinData.Sales.OrderId

  @primary_key {:id, OrderId, autogenerate: false}

  schema "magasin_sale_orders" do
    field :email, Email
    field :product_id, Catalog.ProductId
    field :quantity, Quantity

    timestamps()
  end
end
