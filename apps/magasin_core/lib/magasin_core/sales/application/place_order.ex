defmodule MagasinCore.Sales.PlaceOrder do
  @moduledoc """
  A command to place an order.
  """

  use CivilCode.Command

  alias MagasinData.{Address, Catalog, Email, Quantity}
  alias MagasinData.Sales.OrderId

  embedded_schema do
    field :order_id, OrderId
    field :email, Email
    field :product_id, Catalog.ProductId
    field :quantity, Quantity
    embeds_one :shipping_address, Address

    embeds_many :line_items, LineItem do
      field :product_id, Catalog.ProductId
      field :quantity, Quantity
    end
  end

  @spec new(Params.t()) :: Result.ok(t) | Result.error(Ecto.Changeset.t(t))
  def new(params) do
    __MODULE__
    |> struct
    |> cast(ensure_map(params), [:order_id, :product_id, :email, :quantity])
    |> cast_embed(:shipping_address)
    |> cast_embed(:line_items, with: &line_item_changeset/2)
    |> validate_required([:email])
    |> apply_action(:update)
  end

  def new!(params) do
    params
    |> new
    |> Result.unwrap!()
  end

  defp ensure_map(params), do: Enum.into(params, %{})

  defp line_item_changeset(struct, params) do
    cast(struct, params, [:product_id, :quantity])
  end

  @spec to_domain(t) :: Result.ok(map)
  def to_domain(command) do
    command |> Map.from_struct() |> Result.ok()
  end
end
