defmodule Magasin.PostalCode do
  @moduledoc false

  use CivilCode.DomainPrimitive

  typedstruct enforce: true do
    field :value, String.t()
  end

  def new(":invalid:"), do: {:error, :invalid}

  def new(value) do
    {:ok, struct(__MODULE__, value: value)}
  end

  defmodule Ecto.Type do
    @moduledoc false

    alias Magasin.PostalCode

    @behaviour Elixir.Ecto.Type

    @impl true
    def type, do: :string

    @impl true
    def cast(val)

    def cast(%PostalCode{} = p), do: {:ok, p}

    def cast(value) when is_binary(value) do
      case PostalCode.new(value) do
        {:ok, postal_code} -> {:ok, postal_code}
        {:error, _reason} -> :error
      end
    end

    @impl true
    def load(value) when is_binary(value) do
      PostalCode.new(value)
    end

    @impl true
    def dump(%PostalCode{} = p), do: p.value
    def dump(_), do: :error
  end
end
