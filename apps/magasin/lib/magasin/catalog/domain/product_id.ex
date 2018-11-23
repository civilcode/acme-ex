defmodule Magasin.Catalog.Domain.ProductId do
  @moduledoc false

  use CivilCode.DomainPrimitive

  defstruct [:value]

  @spec new(String.t()) :: {:ok, t} | {:error, :must_be_uuid}
  def new(value) when is_nil(value), do: {:error, :must_be_uuid}

  def new(value) do
    {:ok, struct(__MODULE__, value: value)}
  end

  def new!() do
    new!(UUID.uuid4())
  end

  def new!(value) do
    {:ok, product_id} = new(value)
    product_id
  end

  def parse(_value), do: nil

  defmodule Ecto.Type do
    @moduledoc false

    alias Magasin.Catalog.Domain.ProductId, as: EntityId

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

    @impl true
    def dump(%EntityId{} = e), do: Elixir.Ecto.UUID.dump(e.value)
    def dump(_), do: :error
  end
end
