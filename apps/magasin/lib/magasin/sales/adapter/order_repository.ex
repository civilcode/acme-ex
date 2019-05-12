defmodule Magasin.Sales.Application.OrderRepository do
  @moduledoc false

  use CivilCode.Repository

  alias CivilCode.RepositoryError
  alias Magasin.Repo
  alias Magasin.Sales.Domain.{Order, OrderId}

  defmodule Schema do
    @moduledoc false
    use Magasin.Schema

    alias Magasin.{Email, Quantity}
    alias Magasin.Catalog.Domain, as: Catalog
    alias Magasin.Sales.Domain.OrderId

    @primary_key {:id, OrderId.Ecto.Type, autogenerate: false}

    schema "magasin_sale_orders" do
      field :email, Email.Ecto.Type
      field :product_id, Catalog.ProductId.Ecto.Type
      field :quantity, Quantity.Ecto.Type

      field :__entity__, :string, virtual: true

      timestamps()
    end
  end

  @impl true
  def next_id do
    OrderId.new!(UUID.uuid4())
  end

  @impl true
  def get(order_id) do
    build(Order, fn ->
      Repo.get!(Schema, order_id)
    end)
  end

  @impl true
  def save(order) do
    result =
      %Schema{}
      |> Ecto.Changeset.change(Entity.get_fields(order, [:id, :email, :product_id, :quantity]))
      |> Ecto.Changeset.unique_constraint(:id, name: :magasin_sale_orders_pkey)
      |> Repo.insert_or_update()

    case result do
      {:ok, order_state} -> Result.ok(order_state.id)
      {:error, changeset} -> RepositoryError.validate(changeset)
    end
  end
end