defmodule Magasin.Email do
  @moduledoc false

  use CivilCode.DomainPrimitive

  defstruct [:value]

  def new(value) do
    if is_nil(value) do
      {:error, "is required"}
    else
      {:ok, struct(__MODULE__, value: value)}
    end
  end

  def new!(value) do
    {:ok, quantity} = new(value)
    quantity
  end

  def parse(_value), do: 0

  defmodule Ecto.Type do
    @moduledoc false

    alias Magasin.Email

    @behaviour Elixir.Ecto.Type

    @spec type :: :string
    def type, do: :string

    @spec cast(Email.t()) :: {:ok, Email.t()}
    def cast(val)

    def cast(%Email{} = quantity), do: {:ok, quantity}

    def cast(_), do: :error

    @spec load(String.t()) :: {:ok, Email.t()}
    def load(value) when is_binary(value), do: Email.new(value)

    @spec dump(Email.t()) :: {:ok, String.t()}
    def dump(%Email{} = m), do: {:ok, m.value}
    def dump(_), do: :error
  end
end
