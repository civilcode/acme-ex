defmodule Magasin.Quantity do
  @moduledoc false

  use CivilCode.DomainPrimitive

  defstruct [:value]

  def new(nil) do
    {:error, "is required"}
  end

  def new(value) when value < 0 do
    {:error, "cannot be negative"}
  end

  def new(value) do
    {:ok, struct(__MODULE__, value: value)}
  end

  def new!(value) do
    {:ok, quantity} = new(value)
    quantity
  end

  def subtract(a, b) do
    new(a.value - b.value)
  end

  def parse(_value), do: 0

  defmodule Ecto.Type do
    @moduledoc false

    alias Magasin.Quantity

    @behaviour Elixir.Ecto.Type

    @spec type :: :integer
    def type, do: :integer

    @spec cast(Quantity.t()) :: {:ok, Quantity.t()}
    def cast(val)

    def cast(%Quantity{} = quantity), do: {:ok, quantity}

    def cast(_), do: :error

    @spec load(integer) :: {:ok, Quantity.t()}
    def load(int) when is_integer(int), do: Quantity.new(int)

    @spec dump(Quantity.t()) :: {:ok, :integer}
    def dump(%Quantity{} = m), do: {:ok, m.value}
    def dump(_), do: :error
  end
end
