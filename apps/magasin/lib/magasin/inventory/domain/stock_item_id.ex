defmodule Magasin.Inventory.Domain.StockItemId do
  @moduledoc false

  use CivilCode.DomainPrimitive

  typedstruct enforce: true do
    field :value, String.t()
  end

  @spec new(String.t()) :: {:ok, t} | {:error, :must_be_uuid}
  def new(value) when is_nil(value), do: {:error, :must_be_uuid}

  def new(value) do
    {:ok, struct(__MODULE__, value: value)}
  end

  defmodule Ecto.Type do
    @moduledoc false

    alias Magasin.Inventory.Domain.StockItemId, as: EntityId

    @behaviour Elixir.Ecto.Type

    @impl true
    def type, do: :uuid

    @impl true
    def cast(val)

    def cast(%EntityId{} = e), do: {:ok, e}

    def cast(_), do: :error

    @impl true
    def load(value) when is_binary(value) do
      {:ok, uuid} = Elixir.Ecto.UUID.load(value)
      EntityId.new(uuid)
    end

    def load(_value), do: :error

    @impl true
    def dump(%EntityId{} = e), do: Elixir.Ecto.UUID.dump(e.value)
    def dump(_), do: :error
  end
end
