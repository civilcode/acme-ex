defmodule Magasin.Sales.OrderId do
  @moduledoc """
  The ID of a order entity.
  """

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

    alias Magasin.Sales.OrderId, as: EntityId

    @behaviour Elixir.Ecto.Type

    @impl true
    def type, do: :uuid

    @impl true
    def cast(val)

    def cast(%EntityId{} = e), do: {:ok, e}

    def cast(value) when is_binary(value) do
      EntityId.new(value)
    end

    def cast(_), do: :error

    @impl true
    def load(value) when is_binary(value) do
      {:ok, uuid} = Elixir.Ecto.UUID.load(value)
      EntityId.new(uuid)
    end

    @impl true
    def dump(%EntityId{} = e), do: Elixir.Ecto.UUID.dump(e.value)
    def dump(_), do: :error
  end
end
