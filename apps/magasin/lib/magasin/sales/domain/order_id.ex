defmodule Magasin.Sales.Domain.OrderId do
  @moduledoc false

  use CivilCode.DomainPrimitive

  defstruct [:value]

  def new(value) do
    {:ok, new!(value)}
  end

  def new!() do
    new!(UUID.uuid4())
  end

  def new!(value) do
    struct(__MODULE__, value: value)
  end

  def parse(_value), do: nil

  defmodule Ecto.Type do
    @moduledoc false

    alias Magasin.Sales.Domain.OrderId, as: EntityId

    @behaviour Elixir.Ecto.Type

    @spec type :: :uuid
    def type, do: :uuid

    @spec cast(EntityId.t()) :: {:ok, EntityId.t()}
    def cast(val)

    def cast(%EntityId{} = e), do: {:ok, e}

    def cast(_), do: :error

    @spec load(String.t()) :: {:ok, EntityId.t()}
    def load(value) when is_binary(value) do
      {:ok, uuid} = Elixir.Ecto.UUID.load(value)
      EntityId.new(uuid)
    end

    @spec dump(EntityId.t()) :: {:ok, String.t()}
    def dump(%EntityId{} = e), do: Elixir.Ecto.UUID.dump(e.value)
    def dump(_), do: :error
  end
end
