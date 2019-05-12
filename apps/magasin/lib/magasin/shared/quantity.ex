defmodule Magasin.Quantity do
  @moduledoc false

  use CivilCode.DomainPrimitive

  typedstruct enforce: true do
    field :value, non_neg_integer
  end

  def new(value) when value < 0 do
    {:error, "cannot be negative"}
  end

  def new(value) do
    {:ok, struct(__MODULE__, value: value)}
  end

  def subtract(a, b) do
    new(a.value - b.value)
  end

  defmodule Ecto.Type do
    @moduledoc false

    alias Magasin.Quantity

    @behaviour Elixir.Ecto.Type

    @spec type :: :integer
    def type, do: :integer

    @spec cast(Quantity.t()) :: {:ok, Quantity.t()}
    def cast(val)

    def cast(%Quantity{} = quantity), do: {:ok, quantity}

    def cast(value) when is_number(value) do
      case Quantity.new(value) do
        {:ok, quantity} -> {:ok, quantity}
        {:error, _reason} -> :error
      end
    end

    def cast(_), do: :error

    @spec load(integer) :: {:ok, Quantity.t()}
    def load(int) when is_integer(int), do: Quantity.new(int)

    @spec dump(Quantity.t()) :: {:ok, :integer}
    def dump(%Quantity{} = m), do: {:ok, m.value}
    def dump(_), do: :error
  end
end
