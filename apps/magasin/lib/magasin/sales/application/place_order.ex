defmodule Magasin.Sales.Application.PlaceOrder do
  @moduledoc false

  use Ecto.Schema
  use CivilCode.Command

  alias CivilCode.{Result, Validation}
  alias Magasin.Catalog.Domain, as: Catalog
  alias Magasin.{Address, Email, Quantity}
  alias Magasin.Sales.Domain.OrderId

  embedded_schema do
    field(:order_id, OrderId.Ecto.Type)
    field(:email, Email.Ecto.Type)
    field(:product_id, Catalog.ProductId.Ecto.Type)
    field(:quantity, Quantity.Ecto.Type)
    embeds_one(:shipping_address, Address)

    embeds_many :line_items, LineItem do
      field(:product_id, Catalog.ProductId.Ecto.Type)
      field(:quantity, Quantity.Ecto.Type)
    end
  end

  import Ecto.Changeset

  @fields [:order_id, :product_id, :email, :quantity]

  @spec to_domain(t) :: {:ok, map} | {:error, Validation.t()}
  def to_domain(command) do
    __MODULE__
    |> struct
    |> cast(to_map(command), @fields)
    |> cast_embed(:shipping_address)
    |> cast_embed(:line_items, with: &line_item_changeset/2)
    |> validate
    |> Validation.validate(command)
    |> Result.map(&to_map/1)
  end

  defp validate(schema), do: validate_required(schema, [:email])

  defp to_map(struct), do: Map.delete(struct, :__struct__)

  defp line_item_changeset(struct, params) do
    cast(struct, params, [:product_id, :quantity])
  end
end
