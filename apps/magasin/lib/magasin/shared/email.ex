defmodule Magasin.Email do
  @moduledoc false

  use CivilCode.DomainPrimitive

  typedstruct enforce: true do
    field :value, String.t()
  end

  @spec new(String.t()) :: {:ok, t} | {:error, :must_be_string}
  def new(value) when is_nil(value), do: {:error, :must_be_string}

  def new(value) do
    {:ok, struct(__MODULE__, value: value)}
  end

  defmodule Ecto.Type do
    @moduledoc false

    alias Magasin.Email

    @behaviour Elixir.Ecto.Type

    @impl true
    def type, do: :string

    @impl true
    def cast(val)

    def cast(%Email{} = quantity), do: {:ok, quantity}

    def cast(value) when is_binary(value) do
      Email.new(value)
    end

    def cast(_), do: :error

    @impl true
    def load(value) when is_binary(value), do: Email.new(value)

    @impl true
    def dump(%Email{} = m), do: {:ok, m.value}
    def dump(_), do: :error
  end
end
